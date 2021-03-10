//
//  ProductsVCCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 27/02/2021.
//

import UIKit
import Firebase
import FirebaseUI


enum DelegateCase {
    case checkConnection
    case addQuantity
}

    // MARK: - Protocol & Delegate


protocol ProductsVCCollectionViewCellDelegate: class {
    func didAddProducts()
    func didNotAddProducts(DelegateCase: DelegateCase)
}


final class ProductsVCCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
    
    
    static let reuseId          = "ProductsVCCollectionViewCell"
    
    let cache                   = NSCache<NSString, UIImage>()
    
    
    
    var productImageView        = ShopImageView(frame: .zero)
    var productTitleLabel       = StoreBoldLabel(with: "Product's name",
                                                from: .left,
                                                ofsize: 20,
                                                ofweight: .bold,
                                                alpha: 1,
                                                color: StoreUIColor.grapefruit ?? .orange)
    var priceLabel              = StoreBoldLabel(with: "$3.50",
                                                 from: .center,
                                                 ofsize: 18,
                                                 ofweight: .semibold,
                                                 alpha: 1,
                                                 color: .white)
    
    var addToBasketButton       = StoreVCButton(fontSize: 20, label: "Add to basket")
    
    var productCounter:         UIStackView!
    let plusButton              = UIButton()
    let minusButton             = UIButton()
    let counter                 = UITextField()
    
    
    var topColorView         = UIView()
    
    var currentProduct:                ProductLocal!
    var currentUser:            UserLocal!

    var count                   = 0
    
    weak var productsVCCollectionViewCellDelegate: ProductsVCCollectionViewCellDelegate!
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureUIStackView()
        configureUIElements()
        layoutUI()
        configureStackViewButtons()
        configureAddToBasketButton()
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
            self.productsVCCollectionViewCellDelegate.didNotAddProducts(DelegateCase: .addQuantity)
            return
        }
        FireManager.shared.addProductToBasket(for: currentUser, with: currentProduct, howMany: count) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.productsVCCollectionViewCellDelegate.didNotAddProducts(DelegateCase: .checkConnection)
            } else {
                self.productsVCCollectionViewCellDelegate.didAddProducts()
            }
        }

        self.count = 0
        DispatchQueue.main.async {
            self.counter.text = String(self.count)
            self.animateAddButtonBasket0110(self.addToBasketButton, animationCase: .decrease10)
        }
    }
    
    
    // MARK: - Button Configuration
    
    private func configureStackViewButtons() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureAddToBasketButton() {
        addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Called Outside
    
    
    func set(with product: ProductLocal, currentUser: UserLocal) {
        self.currentProduct            = product
        self.currentUser        = currentUser
        productTitleLabel.text  = product.name
        priceLabel.text         = "$\(String(product.price)) Per Piece"
        downloadImage(from: product.id)
    }
    
    
    // MARK: - Firebase
    
    
    private func downloadImage(from category: String) {
        FireManager.shared.retrieveImageWithPathReferenceFromDocument(from: category, categoryOrProduct: .product) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.productImageView.image = image }
        }
    }

    
    // MARK: - Cell configuration
    
    
    private func configureCell() {
        backgroundColor                     = StoreUIColor.creamWhite
        layer.cornerRadius                  = 15
//        layer.borderWidth                   = 1
//        layer.borderColor                   = StoreUIColor.storePrimaryText?.cgColor
    }
    
    
    // MARK: - Layout Configuration
    
    
    private func configureUIStackView() {
        plusButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        plusButton.tintColor = .white
        
        minusButton.setImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        minusButton.tintColor = .white
        
        counter.text = String(count)
        counter.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        counter.textColor = .white
        counter.textAlignment = .center
        counter.isEnabled = false
        
        productCounter                      = UIStackView()
        productCounter.axis                 = .horizontal
        productCounter.distribution         = .fillEqually
        productCounter.alignment            = .center
        
        productCounter.addArrangedSubview(minusButton)
        productCounter.addArrangedSubview(counter)
        productCounter.addArrangedSubview(plusButton)
    }
    
    
    private func configureUIElements() {
        topColorView.backgroundColor     = StoreUIColor.grapefruit
        topColorView.layer.cornerRadius  = 45
        topColorView.mask                = mask
        
        productImageView.layer.cornerRadius = 0
        
        addToBasketButton.setTitleColor(StoreUIColor.grapefruit, for: .normal)
        addToBasketButton.backgroundColor = .white
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        productCounter.translatesAutoresizingMaskIntoConstraints    = false
        topColorView.translatesAutoresizingMaskIntoConstraints      = false
    
        addSubviews(productTitleLabel, topColorView)
        topColorView.addSubviews(priceLabel, addToBasketButton, productCounter, productImageView)
        
//        debugConfiguration(productImageView, productTitleLabel, priceLabel, addToBasketButton, productCounter, topColorView)
        
        NSLayoutConstraint.activate([
            productTitleLabel.topAnchor.constraint          (equalTo: topAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint      (equalTo: leadingAnchor, constant: 0),
            productTitleLabel.trailingAnchor.constraint     (equalTo: trailingAnchor, constant: 0),
            productTitleLabel.heightAnchor.constraint       (equalToConstant: 30),
            
            productImageView.topAnchor.constraint           (equalTo: productTitleLabel.bottomAnchor, constant: 0),
            productImageView.bottomAnchor.constraint        (equalTo: bottomAnchor, constant: 0),
            productImageView.leadingAnchor.constraint       (equalTo: leadingAnchor, constant: 0),
            productImageView.widthAnchor.constraint         (equalTo: productImageView.heightAnchor),
            
            priceLabel.topAnchor.constraint                 (equalTo: productTitleLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint             (equalTo: productImageView.trailingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint            (equalTo: trailingAnchor),
            priceLabel.heightAnchor.constraint              (equalToConstant: 40),
            
            productCounter.centerYAnchor.constraint         (equalTo: centerYAnchor, constant: 10),
            productCounter.centerXAnchor.constraint         (equalTo: priceLabel.centerXAnchor, constant: 0),
            productCounter.widthAnchor.constraint           (equalToConstant: 130),
            productCounter.heightAnchor.constraint          (equalToConstant: 50),
            
            addToBasketButton.topAnchor.constraint          (equalTo: productCounter.bottomAnchor, constant: 10),
            addToBasketButton.centerXAnchor.constraint      (equalTo: productCounter.centerXAnchor, constant: 0),
            addToBasketButton.widthAnchor.constraint        (equalToConstant: 140),
            addToBasketButton.heightAnchor.constraint       (equalToConstant: 44),
            
            topColorView.topAnchor.constraint               (equalTo: productTitleLabel.bottomAnchor, constant: 0),
            topColorView.leadingAnchor.constraint           (equalTo: leadingAnchor, constant: 0),
            topColorView.trailingAnchor.constraint          (equalTo: trailingAnchor, constant: 0),
            topColorView.bottomAnchor.constraint            (equalTo: bottomAnchor, constant: 0),
            
            
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
                            viewToAnimate.backgroundColor = StoreUIColor.black
                            viewToAnimate.setTitle("Total $\(String(format: "%.2f", self.currentProduct.price * Double(self.count)))", for: .normal)
                            viewToAnimate.setTitleColor(StoreUIColor.mint, for: .normal)
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
                            viewToAnimate.backgroundColor = .white
                            viewToAnimate.setTitle("Add to Basket", for: .normal)
                            viewToAnimate.setTitleColor(StoreUIColor.grapefruit, for: .normal)
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
