//
//  BasketCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 05/03/2021.
//

import UIKit

class BasketCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
    static let reuseId = "SpeicificCellName"
    
    let cache               = NSCache<NSString, UIImage>()
    
    var categoryImageView   = ShopImageView(frame: .zero)
    #warning("Refactor later so its initialised in a function set")
    var productLabel        = StoreSecondaryTitleLabel(from: .left, alpha: 1)
    
    var priceLabel          = StoreBodyLabel(from: .center, alpha: 1)
    var xLabel              = StoreBodyLabel(from: .center, alpha: 1)
    var quantityLabel       = StoreBodyLabel(from: .center, alpha: 1)
    var totalProductLabel   = StoreBodyLabel(from: .center, alpha: 1)
    
    var cellSeparator       = UIView()
    
    
    var product: ProductLocal!
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureLine()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Called Outside
    
    
    func set(with basketProduct: ProductLocal) {
        self.product = basketProduct
        downloadImage(from: basketProduct.id)
        productLabel.text          = product.name
        priceLabel.text             = "$\(String(format: "%.2f" , product.price * product.discountMlt))"
        xLabel.text                 = "x"
        quantityLabel.text          = String(product.quantity)
        totalProductLabel.text      = "Total: $\(String(format: "%.2f" , product.price * product.discountMlt * Double(product.quantity)))"
    }
    // let doubleStr = String(format: "%.2f", myDouble) // "3.14"
    
    // MARK: - Firebase
    
    
    private func downloadImage(from category: String) {
        FireManager.shared.retrieveImageWithPathReferenceFromDocument(from: category, categoryOrProduct: .product) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.categoryImageView.image = image }
        }
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() { backgroundColor = StoreUIColor.creamWhite }
    
    
    private func configureLine() {
        cellSeparator.backgroundColor = StoreUIColor.orange
    }
    
    
    private func layoutUI() {
        cellSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(categoryImageView, productLabel, priceLabel, xLabel, quantityLabel, totalProductLabel, cellSeparator)
//        debugConfiguration(categoryImageView, productLabel, priceLabel, xLabel, quantityLabel, totalProductLabel)
        
        NSLayoutConstraint.activate([
            categoryImageView.centerYAnchor.constraint      (equalTo: self.centerYAnchor),
            categoryImageView.leadingAnchor.constraint      (equalTo: self.leadingAnchor, constant: 5),
            categoryImageView.heightAnchor.constraint       (equalToConstant: 60),
            categoryImageView.widthAnchor.constraint        (equalToConstant: 60),
            
            productLabel.topAnchor.constraint              (equalTo: categoryImageView.topAnchor),
            productLabel.leadingAnchor.constraint          (equalTo: categoryImageView.trailingAnchor, constant: 10),
            productLabel.trailingAnchor.constraint         (equalTo: self.trailingAnchor, constant: 0),
            productLabel.heightAnchor.constraint           (equalToConstant: 30),
            
            priceLabel.topAnchor.constraint                 (equalTo: productLabel.bottomAnchor, constant: 0),
            priceLabel.leadingAnchor.constraint             (equalTo: productLabel.leadingAnchor, constant: 0),
            priceLabel.widthAnchor.constraint               (equalToConstant: 65),
            priceLabel.heightAnchor.constraint              (equalToConstant: 30),
            
            xLabel.topAnchor.constraint                     (equalTo: priceLabel.topAnchor, constant: 0),
            xLabel.leadingAnchor.constraint                 (equalTo: priceLabel.trailingAnchor, constant: 0),
            xLabel.widthAnchor.constraint                   (equalToConstant: 20),
            xLabel.heightAnchor.constraint                  (equalToConstant: 30),
            
            quantityLabel.topAnchor.constraint              (equalTo: priceLabel.topAnchor, constant: 0),
            quantityLabel.leadingAnchor.constraint          (equalTo: xLabel.trailingAnchor, constant: 0),
            quantityLabel.widthAnchor.constraint            (equalToConstant: 25),
            quantityLabel.heightAnchor.constraint           (equalToConstant: 30),
            
            totalProductLabel.topAnchor.constraint          (equalTo: priceLabel.topAnchor, constant: 0),
            totalProductLabel.leadingAnchor.constraint      (equalTo: quantityLabel.trailingAnchor, constant: 0),
            totalProductLabel.trailingAnchor.constraint     (equalTo: trailingAnchor, constant: -5),
            totalProductLabel.heightAnchor.constraint       (equalToConstant: 30),
            
            cellSeparator.topAnchor.constraint              (equalTo: priceLabel.bottomAnchor, constant: 0),
            cellSeparator.leadingAnchor.constraint          (equalTo: priceLabel.leadingAnchor, constant: 0),
            cellSeparator.trailingAnchor.constraint         (equalTo: totalProductLabel.trailingAnchor, constant: -40),
            cellSeparator.heightAnchor.constraint           (equalToConstant: 1),
        ])
    }
}
