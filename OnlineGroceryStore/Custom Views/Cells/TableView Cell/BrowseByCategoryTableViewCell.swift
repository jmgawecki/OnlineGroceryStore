//
//  BrowseByCategoryTableViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import Firebase
import FirebaseUI

final class BrowseByCategoryTableViewCell: UITableViewCell {
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
                                             color: StoreUIColor.grapefruit ?? .orange)
    
    var currentCategory: String!
    
    
    // MARK: - Override and Initialise
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Called Outside
    
    
    func set(with categoryTitle: String) {
        categoryLabel.text = categoryTitle
        downloadImage(from: categoryTitle)
    }
    
    
    // MARK: - Firebase
    
    
    private func downloadImage(from category: String) {
        FireManager.shared.retrieveImageWithPathReferenceFromDocument(from: category, categoryOrProduct: .category) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.categoryImageView.image = image }
        }
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() { backgroundColor = StoreUIColor.creamWhite }
    
    
    private func configure() {
        addSubviews(categoryImageView, categoryLabel)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            categoryImageView.centerYAnchor.constraint  (equalTo: self.centerYAnchor),
            categoryImageView.leadingAnchor.constraint  (equalTo: self.leadingAnchor, constant: padding),
            categoryImageView.heightAnchor.constraint   (equalToConstant: 60),
            categoryImageView.widthAnchor.constraint    (equalToConstant: 60),
            
            categoryLabel.centerYAnchor.constraint      (equalTo: self.centerYAnchor),
            categoryLabel.leadingAnchor.constraint      (equalTo: categoryImageView.trailingAnchor, constant: 24),
            categoryLabel.trailingAnchor.constraint     (equalTo: self.trailingAnchor, constant: -padding),
            categoryLabel.heightAnchor.constraint       (equalToConstant: 40)
        ])
    }
}
