//
//  OrdersVCTableViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 03/03/2021.
//

import UIKit
import Firebase
import FirebaseUI

class OrdersVCTableViewCell: UITableViewCell {
    // MARK: - Declaration
    
    
    static let reuseID   = "BrowseByCategoryCell"
    
    let cache            = NSCache<NSString, UIImage>()
    
    #warning("Refactor later so its initialised in a function set")
    var orderLabel       = StoreBoldLabel(with: "",
                                          from: .left,
                                          ofsize: 20,
                                          ofweight: .bold,
                                          alpha: 1,
                                          color: StoreUIColor.grapefruit ?? .orange)
    var dateLabel        = StoreBoldLabel(with: "",
                                          from: .left,
                                          ofsize: 15,
                                          ofweight: .medium,
                                          alpha: 1,
                                          color: StoreUIColor.grapefruit ?? .orange )
    
    var product: Order!
    
    
    // MARK: - Override and Initialise
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Called Outside
    
    
    func set(with order: Order) {
        orderLabel.text = "Order: \(order.orderNumber)"
        dateLabel.text = order.date
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() { backgroundColor = StoreUIColor.creamWhite }
    
    private func configure() {
        addSubviews(orderLabel, dateLabel)
//        accessoryType           = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            orderLabel.topAnchor.constraint             (equalTo: topAnchor),
            orderLabel.leadingAnchor.constraint         (equalTo: leadingAnchor, constant: 0),
            orderLabel.trailingAnchor.constraint        (equalTo: trailingAnchor, constant: 0),
            orderLabel.heightAnchor.constraint          (equalToConstant: 40),
            
            dateLabel.topAnchor.constraint              (equalTo: orderLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint          (equalTo: leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint         (equalTo: trailingAnchor, constant: 0),
            dateLabel.heightAnchor.constraint           (equalToConstant: 40),
        ])
    }
}
