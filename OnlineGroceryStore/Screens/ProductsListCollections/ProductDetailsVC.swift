//
//  ProductDetailsVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit


    // MARK: - Protocol & Delegate


protocol ProductDetailVCDelegate: class {
    /// Communicaiton path ProductDetailsVC --> CategoriesVC
   func productAddedToBasket()
}


protocol ProductDetailVCDelegateForHomeVC: class {
    /// Communication path ProductDetailsVC --> SpecialOffersVC/ FavoritesVC --> HomeVC
    func dismissProductDetailVC()
}


enum AddToBasketButtonAnimation {
    case increaseDecrease
    case increase01
    case decrease10
}


final class ProductDetailsVC: UIViewController {
    // MARK: - Declaration
    
    
    var productImageView    = ShopImageView(frame: .zero)
    
    var productTitleLabel   = StoreTitleLabel(from: .left, alpha: 1)
    var priceLabel          = StoreSecondaryTitleLabel(from: .left, alpha: 1)
    var descriptionTextView = GroceryTextView(with: "Product's Description")
    
    var addToBasketButton   = StoreVCButton(fontSize: 20, label: "Add")
    
    var productCounter:     UIStackView!
    let plusButton          = UIButton()
    let minusButton         = UIButton()
    let counter             = UITextField()
    var count               = 0
    
    var currentUser:        UserLocal!
    var currentProduct:     ProductLocal!
    
    weak var productDetailVCDelegate: ProductDetailVCDelegate!
    weak var productDetailVCDelegateForHomeVC: ProductDetailVCDelegateForHomeVC!
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIStackView()
        configureUIElements()
        layoutUI()
        configureStackViewButtons()
        configureAddToBasketButton()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { FireManager.shared.clearCache() }
    
    
    init(currentProduct: ProductLocal, currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser            = currentUser
        self.currentProduct         = currentProduct
        productTitleLabel.text      = currentProduct.name
        descriptionTextView.text    = currentProduct.description
        counter.text                = String(currentProduct.quantity)
        count                       = currentProduct.quantity
        priceLabel.text             = "$\(String(format: "%.2f", currentProduct.price))"
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func plusButtonTapped() {
        animateCounterView(counter)
            // animateButtonView(addToBasketButton.titleLabel!)
        if count == 0 {
            count += 1
            animateAddButtonBasket0110(addToBasketButton, animationCase: .increase01)
            // if from 0 to 1 then
            // 1. change color
            // 2. change title to Add $totalPrice
        } else {
            count += 1
            animateAddButtonBasket0110(addToBasketButton, animationCase: .increaseDecrease)
            // if it wasnt 0 ( so 1,2,3,4,5)
            // 1. change title to Add $newTotalPrice
        }
        DispatchQueue.main.async { self.counter.text = String(self.count) }
    }
    
    
    @objc private func minusButtonTapped() {
        if count > 0 {
            animateCounterView(counter)
            if count == 1 {
                count -= 1
                animateAddButtonBasket0110(addToBasketButton, animationCase: .decrease10)
                // if from count = 1
                // 1. change color to gray
                // 2. change title to "Add"
            } else {
                animateAddButtonBasket0110(addToBasketButton, animationCase: .increaseDecrease)
                count -= 1
                // if from count >= 2
                // 2. change title to Add $newTotalPrice
            }
            DispatchQueue.main.async { self.counter.text = String(self.count) }
        }
    }
    
    
    @objc private func addToBasketButtonTapped(sender: UIView) {
        animateButtonView(sender)
        
        guard count > 0 else {
            presentStoreAlertOnMainThread(title: .failure, message: .addSomeQuantity, button: .willDo, image: .concernedBlackGirlR056)
            return
        }
        FireManager.shared.addProductToBasket(for: currentUser, with: currentProduct, howMany: count) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .none:
                self.dismiss(animated: true)
                if (self.productDetailVCDelegate != nil) {
                    self.productDetailVCDelegate.productAddedToBasket()
                } else if (self.productDetailVCDelegateForHomeVC != nil) {
                    self.productDetailVCDelegateForHomeVC.dismissProductDetailVC()
                }
            case .some(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .concernedBlackGirlR056)
            }
        }

        self.count = 0
        DispatchQueue.main.async { self.counter.text = String(self.count) }
    }
    
    
    // MARK: - Firebase
    
    
    func getProductImage(for productId: String) {
        FireManager.shared.retrieveImageWithPathReferenceFromDocument(from: productId, categoryOrProduct: .product) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.productImageView.image = image }
        }
    }
    
    
    // MARK: - Private function
    
    
    private func configureStackViewButtons() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureAddToBasketButton() {
        addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureVC() {
        view.backgroundColor = colorAsUIColor.storeBackground
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    //MARK: - Layout configuration
    
    
    private func configureUIStackView() {
        plusButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        plusButton.tintColor            = colorAsUIColor.storeTertiary
        
        minusButton.setImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        minusButton.tintColor           = colorAsUIColor.storeTertiary
        
        counter.text                    = String(count)
        counter.font                    = UIFont.preferredFont(forTextStyle: .title2)
        counter.textColor               = colorAsUIColor.storeTertiary
        counter.textAlignment           = .center
        counter.isEnabled               = false
        
        productCounter                  = UIStackView()
        productCounter.axis             = .horizontal
        productCounter.distribution     = .fillEqually
        productCounter.alignment        = .center
        
        productCounter.addArrangedSubview(minusButton)
        productCounter.addArrangedSubview(counter)
        productCounter.addArrangedSubview(plusButton)
    }
    
    
    private func configureUIElements() {
        addToBasketButton.backgroundColor = .gray
        addToBasketButton.setTitleColor(.black, for: .normal)
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        productCounter.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(productImageView, productTitleLabel, priceLabel, descriptionTextView, addToBasketButton, productCounter)
        
//        debugConfiguration(productImageView, productTitleLabel, priceLabel, descriptionTextView, addToBasketButton, productCounter)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint           (equalTo: view.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint       (equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint      (equalTo: view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint        (equalTo: productImageView.widthAnchor),
            
            productTitleLabel.topAnchor.constraint          (equalTo: productImageView.bottomAnchor, constant: 10),
            productTitleLabel.leadingAnchor.constraint      (equalTo: view.leadingAnchor, constant: 20),
            productTitleLabel.trailingAnchor.constraint     (equalTo: view.trailingAnchor, constant: -20),
            productTitleLabel.heightAnchor.constraint       (equalToConstant: 30),
            
            priceLabel.topAnchor.constraint                 (equalTo: productTitleLabel.bottomAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint             (equalTo: view.leadingAnchor, constant: 20),
            priceLabel.widthAnchor.constraint               (equalToConstant: 100),
            priceLabel.heightAnchor.constraint              (equalToConstant: 30),
            
            descriptionTextView.topAnchor.constraint        (equalTo: priceLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint    (equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint   (equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint     (equalToConstant: 100),
            
            addToBasketButton.bottomAnchor.constraint       (equalTo: view.bottomAnchor, constant: -30),
            addToBasketButton.leadingAnchor.constraint      (equalTo: view.leadingAnchor, constant: 20),
            addToBasketButton.widthAnchor.constraint        (equalToConstant: 200),
            addToBasketButton.heightAnchor.constraint       (equalToConstant: 50),
            
            productCounter.bottomAnchor.constraint          (equalTo: view.bottomAnchor, constant: -30),
            productCounter.trailingAnchor.constraint        (equalTo: view.trailingAnchor, constant: -20),
            productCounter.widthAnchor.constraint           (equalToConstant: 100),
            productCounter.heightAnchor.constraint          (equalToConstant: 50),
        ])
    }
    
    
    // MARK: - Animation
    
    
    private func animateButtonView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
    
    
    private func animateAddButtonBasket0110(_ viewToAnimate: UIButton, animationCase: AddToBasketButtonAnimation) {
        switch animationCase {
        case .increaseDecrease:
            UIView.animate(withDuration: 0.25, animations: {
                viewToAnimate.titleLabel!.alpha = 0
            }) { [weak self] (true) in
                guard let self = self else { return }
                switch true {
                case true:
                    UIView.animate(withDuration: 0.25, animations: {
                        DispatchQueue.main.async {
                            viewToAnimate.setTitle("Total $\(String(format: "%.2f", self.currentProduct.price * Double(self.count)))", for: .normal)
                        }
                        viewToAnimate.titleLabel!.alpha = 1
                        
                    } )
                case false:
                    return
                }
            }
            
        case .increase01:
            UIView.animate(withDuration: 0.25, animations: {
                viewToAnimate.alpha = 0
            }) { (true) in
                switch true {
                case true:
                    UIView.animate(withDuration: 0.25, animations: {
                        DispatchQueue.main.async {
                            viewToAnimate.backgroundColor = colorAsUIColor.storeSecondary
                            viewToAnimate.setTitle("Total $\(String(format: "%.2f", self.currentProduct.price * Double(self.count)))", for: .normal)
                        }
                        viewToAnimate.alpha = 1
                        
                    } )
                case false:
                    return
                }
            }
            
        case .decrease10:
            UIView.animate(withDuration: 0.2, animations: {
                viewToAnimate.alpha = 0
            }) { (true) in
                switch true {
                case true:
                    UIView.animate(withDuration: 0.2, animations: {
                        DispatchQueue.main.async {
                            viewToAnimate.backgroundColor = .lightGray
                            viewToAnimate.setTitle("Add to Basket", for: .normal)
                        }
                        viewToAnimate.alpha = 1
                        
                    } )
                case false:
                    return
                }
            }
            
        }
    }
    
    
    
    private func animateCounterView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.1, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.1, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
    
}


//MARK: - Extension

