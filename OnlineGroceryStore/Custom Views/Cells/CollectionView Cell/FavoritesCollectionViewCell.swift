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
    static let reuseId      = "SpeicificCellName"
    
    let cache               = NSCache<NSString, UIImage>()
    
    var productImageView    = ShopImageView(frame: .zero)
    
    var cellContentView     = UIView()
    
    var productTitleLabel   = StoreBoldLabel(with: "Product's name",
                                             from: .center,
                                             ofsize: 15,
                                             ofweight: .medium,
                                             alpha: 1,
                                             color: StoreUIColor.grapefruit ?? .orange)
    var priceLabel          = StoreBoldLabel(with: "$3.50",
                                             from: .center,
                                             ofsize: 15,
                                             ofweight: .semibold,
                                             alpha: 1,
                                             color: StoreUIColor.darkGreen ?? .green)
    
    var product: ProductLocal!
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
       
        layoutUI()
        configureUIElements()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Called Outside
    
    
    func set(with product: ProductLocal) {
        self.product = product
        priceLabel.text = "$\(String(format: "%.2f" ,product.price)) Per Piece"
        productTitleLabel.text = product.name
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
        layer.borderWidth                   = 1
        layer.borderColor                   = StoreUIColor.grapefruit?.cgColor
    }
    
    
    private func configureUIElements() {
        let mask                            = UIView(frame: bounds)
        mask.backgroundColor                = .black
        
        cellContentView.backgroundColor     = StoreUIColor.creamWhite
        cellContentView.mask                = mask
        cellContentView.layer.cornerRadius  = 20
        
        productImageView.layer.cornerRadius = 15
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        cellContentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(productImageView, cellContentView ,productTitleLabel, priceLabel)
        cellContentView.addSubviews(productTitleLabel, priceLabel)
//        debugConfiguration(productImageView, productTitleLabel, priceLabel, self)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint           (equalTo: topAnchor, constant: 0),
            productImageView.leadingAnchor.constraint       (equalTo: leadingAnchor, constant: 0),
            productImageView.trailingAnchor.constraint      (equalTo: trailingAnchor, constant: 0),
            productImageView.heightAnchor.constraint        (equalTo: productImageView.widthAnchor),
            
            cellContentView.topAnchor.constraint            (equalTo: productImageView.bottomAnchor, constant: -20),
            cellContentView.leadingAnchor.constraint        (equalTo: leadingAnchor, constant: 0),
            cellContentView.trailingAnchor.constraint       (equalTo: trailingAnchor, constant: 30),
            cellContentView.bottomAnchor.constraint         (equalTo: bottomAnchor, constant: 30),
            
            productTitleLabel.topAnchor.constraint          (equalTo: cellContentView.topAnchor, constant: 0),
            productTitleLabel.leadingAnchor.constraint      (equalTo: cellContentView.leadingAnchor, constant: 0),
            productTitleLabel.trailingAnchor.constraint     (equalTo: trailingAnchor, constant: 0),
            productTitleLabel.heightAnchor.constraint       (equalToConstant: 45),
            
            priceLabel.topAnchor.constraint                 (equalTo: productTitleLabel.bottomAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint             (equalTo: leadingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint            (equalTo: trailingAnchor, constant: 0),
            priceLabel.heightAnchor.constraint              (equalToConstant: 20),
        ])
    }
}
