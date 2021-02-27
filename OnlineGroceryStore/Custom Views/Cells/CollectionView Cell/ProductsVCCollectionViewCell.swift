//
//  ProductsVCCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 27/02/2021.
//

import UIKit
import Firebase
import FirebaseUI

class ProductsVCCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
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
    var product: Product!
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Called Outside
    
    
    func set(with product: Product) {
        self.product = product
        productTitleLabel.text = product.name
        priceLabel.text = "$\(String(product.price))"
        retrieveImageWithPathReferenceFromDocument(from: product.id)
        if product.favorite == true {
            favoriteSystemButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteSystemButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    
    private func retrieveImageWithPathReferenceFromDocument(from category: String) {
        Firestore.firestore().collection("products").document(category).getDocument { [weak self] (category, error) in
            guard let self = self else { return }
            let pathReference = Storage.storage().reference(withPath: "productImage/\(category?.data()!["imageReference"] as! String)")
            
            pathReference.getData(maxSize: 1 * 2024 * 2024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.productImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    // MARK: - Cell configuration
    
    
    private func configureCell() {
        backgroundColor                     = .systemBackground
        layer.cornerRadius                  = 15
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        favoriteSystemButton.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(productImageView, productTitleLabel, priceLabel, favoriteSystemButton, addToBasketButton)
        debugConfiguration(productImageView, productTitleLabel, priceLabel, favoriteSystemButton, addToBasketButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            productImageView.heightAnchor.constraint(equalToConstant: 175),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            productTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            productTitleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            priceLabel.widthAnchor.constraint(equalToConstant: 80),
            priceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            favoriteSystemButton.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: 0),
            favoriteSystemButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            favoriteSystemButton.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
            favoriteSystemButton.widthAnchor.constraint(equalTo: favoriteSystemButton.heightAnchor),
            
            addToBasketButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            addToBasketButton.topAnchor.constraint(equalTo: favoriteSystemButton.bottomAnchor, constant: 10),
            addToBasketButton.widthAnchor.constraint(equalToConstant: 150),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
