//
//  FavoritesCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import FirebaseUI
import Firebase

final class FavoritesCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
    static let reuseId = "SpeicificCellName"
    
    let cache = NSCache<NSString, UIImage>()
    
    var productImageView = ShopImageView(frame: .zero)
    var productTitleLabel = StoreBoldLabel(with: "Product's name",
                                           from: .center,
                                           ofsize: 15,
                                           ofweight: .medium,
                                           alpha: 1,
                                           color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    
    var priceLabel = StoreBoldLabel(with: "$3.50",
                                    from: .center,
                                    ofsize: 15,
                                    ofweight: .semibold,
                                    alpha: 1,
                                    color: UIColor(named: colorAsString.storeTertiary) ?? .orange)
    
    var product: Product!
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Called Outside
    
    
    func set(with product: Product) {
        self.product = product
        priceLabel.text = "$\(String(product.price))"
        productTitleLabel.text = product.name
        retrieveImageWithPathReferenceFromDocument(from: product.id)
    }
    
    
    private func retrieveImageWithPathReferenceFromDocument(from category: String) {
        let cacheKey = NSString(string: category)
        if let image = cache.object(forKey: cacheKey) { self.productImageView.image = image; return}
        /// Perhaps products/diary/
        Firestore.firestore().collection("products").document(category).getDocument { [weak self] (category, error) in
            guard let self = self else { return }
            let pathReference = Storage.storage().reference(withPath: "productImage/\(category?.data()!["imageReference"] as! String)")
            
            pathReference.getData(maxSize: 1 * 2024 * 2024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.productImageView.image = UIImage(data: data!)
                    }
                    self.cache.setObject(UIImage(data: data!)!, forKey: cacheKey)
                }
            }
        }
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() {
        backgroundColor                     = UIColor(named: colorAsString.storeBackground)
        layer.cornerRadius                  = 15
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        
        addSubviews(productImageView, productTitleLabel, priceLabel)
//        debugConfiguration(productImageView, productTitleLabel, priceLabel)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            productTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            productTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            productTitleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint(equalTo: productTitleLabel.trailingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            priceLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
