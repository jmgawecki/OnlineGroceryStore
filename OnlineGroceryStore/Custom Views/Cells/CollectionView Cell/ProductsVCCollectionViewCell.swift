//
//  ProductsVCCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 27/02/2021.
//

import UIKit
import Firebase
import FirebaseUI

final class ProductsVCCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
    
    
    static let reuseId          = "SpeicificCellName"
    
    let cache                   = NSCache<NSString, UIImage>()
    
    
    
    var productImageView        = ShopImageView(frame: .zero)
    var productTitleLabel       = StoreBoldLabel(with: "Product's name",
                                                from: .left,
                                                ofsize: 20,
                                                ofweight: .bold,
                                                alpha: 1,
                                                color: colorAsUIColor.storePrimaryText ?? .orange)
    var priceLabel              = StoreBoldLabel(with: "$3.50",
                                                 from: .center,
                                                 ofsize: 18,
                                                 ofweight: .semibold,
                                                 alpha: 1,
                                                 color: colorAsUIColor.storePrimaryText ?? .orange)
    
    var addToBasketButton       = StoreVCButton(fontSize: 20, label: "Add")
    
    var productCounter:         UIStackView!
    let plusButton              = UIButton()
    let minusButton             = UIButton()
    let counter                 = UITextField()
    
    var product:                ProductLocal!
    var currentUser:            UserLocal!

    var count                   = 0
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIStackView()
        layoutUI()
        configureStackViewButtons()
        configureAddToBasketButton()
    }
    

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func plusButtonTapped() {
        animateCounterView(counter)
        count += 1
        DispatchQueue.main.async {
            self.counter.text = String(self.count)
        }
    }
    
    
    @objc private func minusButtonTapped() {
        if count > 0 {
            animateCounterView(counter)
            count -= 1
            DispatchQueue.main.async { self.counter.text = String(self.count) }
        }
        
    }
    
    
    @objc private func addToBasketButtonTapped(sender: UIView) {
        animateButtonView(sender)
        FireManager.shared.addProductToBasket(for: currentUser, with: product, howMany: count) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        self.count = 0
        DispatchQueue.main.async { self.counter.text = String(self.count) }
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
        self.product            = product
        self.currentUser        = currentUser
        productTitleLabel.text  = product.name
        priceLabel.text         = "$\(String(product.price))"
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
        backgroundColor                     = colorAsUIColor.storeBackground
        layer.cornerRadius                  = 15
        layer.borderWidth                   = 1
        layer.borderColor                   = colorAsUIColor.storePrimaryText?.cgColor
    }
    
    
    // MARK: - Layout Configuration
    
    
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
        productCounter.translatesAutoresizingMaskIntoConstraints = false
        minusButton.layer.borderWidth = 2
        counter.layer.borderWidth = 2
        productCounter.addArrangedSubview(minusButton)
        productCounter.addArrangedSubview(counter)
        productCounter.addArrangedSubview(plusButton)
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        addSubviews(productImageView, productTitleLabel, priceLabel, addToBasketButton, productCounter)
//        debugConfiguration(productImageView, productTitleLabel, priceLabel, favoriteSystemButton, addToBasketButton, productCounter)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint           (equalTo: topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint       (equalTo: leadingAnchor, constant: 0),
            productImageView.heightAnchor.constraint        (equalToConstant: 175),
            productImageView.widthAnchor.constraint         (equalTo: productImageView.heightAnchor),
            
            priceLabel.topAnchor.constraint                 (equalTo: topAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint             (equalTo: productImageView.trailingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint            (equalTo: trailingAnchor),
            priceLabel.heightAnchor.constraint              (equalToConstant: 40),
            
            productCounter.topAnchor.constraint             (equalTo: priceLabel.bottomAnchor, constant: 0),
            productCounter.leadingAnchor.constraint         (equalTo: productImageView.trailingAnchor, constant: 0),
            productCounter.trailingAnchor.constraint        (equalTo: trailingAnchor, constant: 0),
            productCounter.heightAnchor.constraint          (equalToConstant: 50),
            
            addToBasketButton.leadingAnchor.constraint      (equalTo: productImageView.trailingAnchor, constant: 0),
            addToBasketButton.topAnchor.constraint          (equalTo: productCounter.bottomAnchor, constant: 10),
            addToBasketButton.widthAnchor.constraint        (equalToConstant: 150),
            addToBasketButton.heightAnchor.constraint       (equalToConstant: 50),
            
            productTitleLabel.topAnchor.constraint          (equalTo: productImageView.bottomAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint      (equalTo: leadingAnchor, constant: 0),
            productTitleLabel.trailingAnchor.constraint     (equalTo: trailingAnchor, constant: 0),
            productTitleLabel.heightAnchor.constraint       (equalToConstant: 60),
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
