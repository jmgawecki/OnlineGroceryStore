//
//  BrowseByCategoryTableViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import Firebase
import FirebaseUI

class BrowseByCategoryTableViewCell: UITableViewCell {
    // MARK: - Declaration
    
    var categoryImageView = ShopImageView(frame: .zero)
    #warning("Refactor later so its initialised in a function set")
    var categoryLabel       = StoreBoldLabel(with: "Category",
                                             from: .left,
                                             ofsize: 20,
                                             ofweight: .medium,
                                             alpha: 1,
                                             color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    
    static let reuseID = "BrowseByCategoryCell"
    
    var currentCategory: String!
    
    
    // MARK: - Override and Initialise
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Called Outside
    
    func set() {
        
    }
    
    func retrieveImageWithUrlFromDocument(from category: String) {
            Firestore.firestore().collection("groceryCategory").document(category).getDocument { (category, error) in
                let storageReference = Storage.storage().reference()
                let urlString = storageReference.child(category?.data()!["imageUrl"] as! String)

                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                urlString.getData(maxSize: 2 * 2024 * 2024) { data, error in
                  if let error = error {
                    print(error.localizedDescription)
                  } else {
                    print("image download succesful!")
                    let image = UIImage(data: data!)
                  }
                }
                    
                    

            }
    }
    
    // MARK: - Cell configuration
    
    private func configureCell() {
        backgroundColor = UIColor(named: colorAsString.storeBackground)
    }
    
    private func configure() {
        addSubviews(categoryImageView, categoryLabel)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            categoryImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            categoryImageView.heightAnchor.constraint(equalToConstant: 60),
            categoryImageView.widthAnchor.constraint(equalToConstant: 60),
            
            categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 24),
            categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            categoryLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
