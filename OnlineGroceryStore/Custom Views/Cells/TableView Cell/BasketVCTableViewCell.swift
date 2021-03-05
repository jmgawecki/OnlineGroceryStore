//
//  BasketVCTableViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 02/03/2021.
//

import UIKit
import Firebase
import FirebaseUI

class BasketVCTableViewCell: UITableViewCell {
    // MARK: - Declaration
    
    
    static let reuseID      = "BrowseByCategoryCell"
    
    let cache               = NSCache<NSString, UIImage>()
    
    var categoryImageView   = ShopImageView(frame: .zero)
    #warning("Refactor later so its initialised in a function set")
    var categoryLabel       = StoreBoldLabel(with: "",
                                             from: .left,
                                             ofsize: 20,
                                             ofweight: .medium,
                                             alpha: 1,
                                             color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    
    var product: ProductLocal!
    
    
    // MARK: - Override and Initialise
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Called Outside
    
    
    func set(with basketProduct: ProductLocal) {
        self.product = basketProduct
        categoryLabel.text = basketProduct.name
        downloadImage(from: basketProduct.id)
    }
    
    
    // MARK: - Firebase
    
    
    private func downloadImage(from category: String) {
        FireManager.shared.retrieveImageWithPathReferenceFromDocument(from: category, categoryOrProduct: .product) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.categoryImageView.image = image }
        }
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() { backgroundColor = UIColor(named: colorAsString.storeBackground) }
    
    
    private func configure() {
        addSubviews(categoryImageView, categoryLabel)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            categoryImageView.centerYAnchor.constraint      (equalTo: self.centerYAnchor),
            categoryImageView.leadingAnchor.constraint      (equalTo: self.leadingAnchor, constant: padding),
            categoryImageView.heightAnchor.constraint       (equalToConstant: 60),
            categoryImageView.widthAnchor.constraint        (equalToConstant: 60),
            
            categoryLabel.centerYAnchor.constraint          (equalTo: self.centerYAnchor),
            categoryLabel.leadingAnchor.constraint          (equalTo: categoryImageView.trailingAnchor, constant: 24),
            categoryLabel.trailingAnchor.constraint         (equalTo: self.trailingAnchor, constant: -padding),
            categoryLabel.heightAnchor.constraint           (equalToConstant: 40)
        ])
    }
}
