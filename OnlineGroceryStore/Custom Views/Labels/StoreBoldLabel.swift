//
//  StoreHeaderTitleLabel.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

final class StoreBoldLabel: UILabel {
    //MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(with text: String, from textAlignment: NSTextAlignment, ofsize font: CGFloat, ofweight weight: UIFont.Weight, alpha: CGFloat, color: UIColor) {
        self.init(frame: .zero)
        self.text           = text
        self.font           = UIFont.systemFont(ofSize: font, weight: weight)
        self.textAlignment  = textAlignment
        self.alpha          = alpha
        self.textColor      = color
    }


    //MARK: - Configuration
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines   = 0
    }
}
