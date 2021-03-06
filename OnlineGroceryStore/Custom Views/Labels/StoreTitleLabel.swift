//
//  StoreTitleLabel.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 05/03/2021.
//

import UIKit

class StoreTitleLabel: UILabel {
    //MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    convenience init(from textAlignment: NSTextAlignment, alpha: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.alpha          = alpha
    }


    //MARK: - Configuration
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines               = 0
        font                        = UIFont.systemFont(ofSize: 25, weight: .bold)
        textColor                   = colorAsUIColor.storePrimaryText ?? .orange
        adjustsFontSizeToFitWidth   = true
    }
}

