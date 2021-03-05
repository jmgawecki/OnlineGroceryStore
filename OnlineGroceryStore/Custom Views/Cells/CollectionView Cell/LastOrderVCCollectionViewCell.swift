//
//  LastOrderVCCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 03/03/2021.
//

import UIKit

class LastOrderVCCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
    
    let cache = NSCache<NSString, UIImage>()
    
    static let reuseId = "SpeicificCellName"
    
    var productImageView = ShopImageView(frame: .zero)
    var productTitleLabel = StoreBoldLabel(with: "Product's name",
                                           from: .left,
                                           ofsize: 20,
                                           ofweight: .bold,
                                           alpha: 1,
                                           color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    var priceLabel = StoreBoldLabel(with: "$3.50",
                                    from: .center,
                                    ofsize: 18,
                                    ofweight: .semibold,
                                    alpha: 1,
                                    color: UIColor(named: colorAsString.storeTertiary) ?? .orange)
    
    var favoriteSystemButton = UIButton()
    var addToBasketButton = StoreButton(fontSize: 20, label: "Add")
    var product: ProductLocal!
    var currentUser: UserLocal!
    
    var productCounter: UIStackView!
    let counter = UITextField()
    let multiplier = UIImageView()
    var count = 0
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIStackView()
        layoutUI()
        configureAddToBasketButton()
    }
    

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
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
    
    
    // MARK: - Private function
    
    
    private func configureAddToBasketButton() {
        addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Called Outside
    
    
    func set(with product: ProductLocal, currentUser: UserLocal) {
        self.product = product
        self.currentUser = currentUser
        self.counter.text = String(product.quantity)
        productTitleLabel.text = product.name
        priceLabel.text = "$\(String(product.price))"
        downloadImage(from: product.id)
        print(product.id)
        if product.favorite == true {
            favoriteSystemButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            favoriteSystemButton.tintColor = UIColor(named: colorAsString.storeTertiary)
        } else {
            favoriteSystemButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            favoriteSystemButton.tintColor = UIColor(named: colorAsString.storeTertiary)
        }
    }
    
    
    private func downloadImage(from category: String) {
        FireManager.shared.retrieveImageWithPathReferenceFromDocument(from: category, categoryOrProduct: .product) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.productImageView.image = image }
        }
    }

    
    // MARK: - Firebase
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() {
        backgroundColor                     = UIColor(named: colorAsString.storeBackground)
        layer.cornerRadius                  = 15
    }
    
    
    // MARK: - Layout Configuration
    
    
    private func configureUIStackView() {
        
        multiplier.layer.borderWidth = 2
        
        counter.text = String(count)
        counter.font = UIFont.preferredFont(forTextStyle: .title2)
        counter.textColor = UIColor(named: colorAsString.storeTertiary)
        counter.textAlignment = .center
        counter.isEnabled = false
        multiplier.image = UIImage(systemName: "xmark")
//        minusButton.setImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
//
        productCounter                   = UIStackView()
        productCounter.axis              = .horizontal
        productCounter.distribution      = .equalSpacing
        productCounter.alignment         = .center
        productCounter.translatesAutoresizingMaskIntoConstraints = false
        counter.layer.borderWidth = 2
        priceLabel.translatesAutoresizingMaskIntoConstraints = true
        priceLabel.layer.borderWidth = 2
        productCounter.addArrangedSubview(priceLabel)
        productCounter.addArrangedSubview(multiplier)
        productCounter.addArrangedSubview(counter)
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        favoriteSystemButton.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(productImageView, productTitleLabel, productCounter)
        debugConfiguration(productImageView, productTitleLabel, productCounter)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            productImageView.heightAnchor.constraint(equalToConstant: 135),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            productCounter.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            productCounter.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 0),
            productCounter.widthAnchor.constraint(equalToConstant: 150),
            productCounter.heightAnchor.constraint(equalToConstant: 50),
            
            productTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            productTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            productTitleLabel.heightAnchor.constraint(equalToConstant: 60),
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