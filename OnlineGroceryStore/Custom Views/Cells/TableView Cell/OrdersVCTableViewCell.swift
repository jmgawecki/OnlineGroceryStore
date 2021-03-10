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
    var orderLabel       = StoreTitleLabel(from: .left, alpha: 1)
    var dateLabel        = StoreBodyLabel(from: .left, alpha: 1)
    var totalLabel       = StoreSecondaryTitleLabel(from: .left, alpha: 1)
    
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
        orderLabel.text     = "Order nr. \(order.orderNumber.dropLast(29))"
        dateLabel.text      = "From \(order.whenOrdered)"
        totalLabel.text     = "Total paid: $\(String(format: "%.2f", countTotal(for: order)))"
    }
    
    
    // MARK: - Private function
    
    
    private func countTotal(for order: Order) -> Double {
        var total = 0.0
        for product in order.products {
            total += Double(product.quantity) * product.price * product.discountMlt
        }
        return total
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() { backgroundColor = StoreUIColor.creamWhite }
    
    private func configure() {
        addSubviews(orderLabel, dateLabel, totalLabel)
//        debugConfiguration(orderLabel,dateLabel, totalLabel)
//        accessoryType           = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            orderLabel.topAnchor.constraint             (equalTo: topAnchor, constant: 5),
            orderLabel.leadingAnchor.constraint         (equalTo: leadingAnchor, constant: 20),
            orderLabel.trailingAnchor.constraint        (equalTo: trailingAnchor, constant: 0),
            orderLabel.heightAnchor.constraint          (equalToConstant: 30),
            
            totalLabel.topAnchor.constraint             (equalTo: orderLabel.bottomAnchor, constant: 5),
            totalLabel.leadingAnchor.constraint         (equalTo: leadingAnchor, constant: 20),
            totalLabel.trailingAnchor.constraint        (equalTo: trailingAnchor, constant: 0),
            totalLabel.heightAnchor.constraint          (equalToConstant: 20),
            
            dateLabel.topAnchor.constraint              (equalTo: totalLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint          (equalTo: leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint         (equalTo: trailingAnchor, constant: 0),
            dateLabel.heightAnchor.constraint           (equalToConstant: 22),
            
            
            
        ])
    }
}
