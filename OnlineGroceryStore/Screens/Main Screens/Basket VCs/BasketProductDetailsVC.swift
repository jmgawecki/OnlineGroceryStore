//
//  BasketProductDetailsVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 06/03/2021.
//

import UIKit


    // MARK: - Protocol and Delegate


protocol BasketProductDetailsVCDelegates: class {
    func updatedProductBasketQuantity()
}


class BasketProductDetailsVC: UIViewController {
    // MARK: - Declaration
    
    
    var productImageView    = ShopImageView(frame: .zero)
    var productTitleLabel   = StoreBoldLabel(with: "Product's Name",
                                             from: .center,
                                             ofsize: 25,
                                             ofweight: .bold,
                                             alpha: 1,
                                             color: colorAsUIColor.storePrimaryText ?? .orange)
    
    var descriptionTextView = GroceryTextView(with: "Product's Description")
    var currentUser:        UserLocal!
    var currentProduct:     ProductLocal!
    
    var addToBasketButton   = StoreVCButton(fontSize: 20, label: "Update")
    
    var productCounter:     UIStackView!
    let plusButton          = UIButton()
    let minusButton         = UIButton()
    let counter             = UITextField()
    var count               = 0
    
    weak var basketProductDetailsVCDelegates: BasketProductDetailsVCDelegates!
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIStackView()
        layoutUI()
        configureStackViewButtons()
        configureAddToBasketButton()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { FireManager.shared.clearCache() }
    
    
    init(currentProduct: ProductLocal, currentUser: UserLocal, basketProductDetailsVCDelegates: BasketProductDetailsVCDelegates) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser            = currentUser
        self.currentProduct         = currentProduct
        productTitleLabel.text      = currentProduct.name
        descriptionTextView.text    = currentProduct.description
        counter.text                = String(currentProduct.quantity)
        count                       = currentProduct.quantity
        self.basketProductDetailsVCDelegates = basketProductDetailsVCDelegates
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func plusButtonTapped() {
        StoreAnimation.animateClickedView(counter, animationDuration: 0.1, middleAlpha: 0.3, endAlpha: 1)
        count += 1
        DispatchQueue.main.async { self.counter.text = String(self.count) }
    }
    
    
    @objc private func minusButtonTapped() {
        if count > 0 {
            StoreAnimation.animateClickedView(counter, animationDuration: 0.1, middleAlpha: 0.3, endAlpha: 1)
            count -= 1
            DispatchQueue.main.async { self.counter.text = String(self.count) }
        }
    }
    
    
    @objc private func addToBasketButtonTapped(sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        guard count > 0 else {
            presentStoreAlertOnMainThread(title: .failure, message: .itemAddedToBasket, button: .willDo, image: .concernedBlackGirlR056)
            return
        }
        FireManager.shared.updateProductBasketQuantity(for: currentUser, with: currentProduct, updatedQuantity: count) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .none:
                self.dismiss(animated: true)
                self.basketProductDetailsVCDelegates.updatedProductBasketQuantity()
                
            case .some(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .ok, image: .happyBlackGirlR056)
            }
        }
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
        plusButton.tintColor = colorAsUIColor.storeTertiary
        
        minusButton.setImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        minusButton.tintColor = colorAsUIColor.storeTertiary
        
        counter.text = String(count)
        counter.font = UIFont.preferredFont(forTextStyle: .title2)
        counter.textColor = colorAsUIColor.storeTertiary
        counter.textAlignment = .center
        counter.isEnabled = false
        
        productCounter                   = UIStackView()
        productCounter.axis              = .horizontal
        productCounter.distribution      = .fillEqually
        productCounter.alignment         = .center
        
        productCounter.addArrangedSubview(minusButton)
        productCounter.addArrangedSubview(counter)
        productCounter.addArrangedSubview(plusButton)
    }
    
    
    private func layoutUI() {
        productCounter.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(productImageView, productTitleLabel, descriptionTextView, productCounter, addToBasketButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint           (equalTo: view.topAnchor, constant: 20),
            productImageView.centerXAnchor.constraint       (equalTo: view.centerXAnchor),
            productImageView.widthAnchor.constraint         (equalToConstant: 300),
            productImageView.heightAnchor.constraint        (equalTo: productImageView.widthAnchor),
                
            productTitleLabel.topAnchor.constraint          (equalTo: productImageView.bottomAnchor, constant: 10),
            productTitleLabel.leadingAnchor.constraint      (equalTo: view.leadingAnchor, constant: 20),
            productTitleLabel.trailingAnchor.constraint     (equalTo: view.trailingAnchor, constant: -20),
            productTitleLabel.heightAnchor.constraint       (equalToConstant: 30),
            
            productCounter.topAnchor.constraint             (equalTo: productTitleLabel.bottomAnchor, constant: 0),
            productCounter.centerXAnchor.constraint         (equalTo: view.centerXAnchor),
            productCounter.widthAnchor.constraint           (equalToConstant: 200),
            productCounter.heightAnchor.constraint          (equalToConstant: 50),
            
            addToBasketButton.topAnchor.constraint          (equalTo: productCounter.bottomAnchor, constant: 0),
            addToBasketButton.centerXAnchor.constraint      (equalTo: view.centerXAnchor),
            addToBasketButton.widthAnchor.constraint        (equalToConstant: 200),
            addToBasketButton.heightAnchor.constraint       (equalToConstant: 50),
            
            descriptionTextView.topAnchor.constraint        (equalTo: addToBasketButton.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint    (equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint   (equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint     (equalToConstant: 100),
        ])
    }
}


//MARK: - Extension

