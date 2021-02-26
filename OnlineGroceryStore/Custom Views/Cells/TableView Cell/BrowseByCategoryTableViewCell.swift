//
//  BrowseByCategoryTableViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

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
