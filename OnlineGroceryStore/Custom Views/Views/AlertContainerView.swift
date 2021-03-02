//
//  AlertContainerView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 01/03/2021.
//

import UIKit

final class AlertContainerView: UIView {
    
    
    //MARK:- Overrides

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- Private functions
    
    
    private func configure() {
        backgroundColor       = .systemBackground
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
