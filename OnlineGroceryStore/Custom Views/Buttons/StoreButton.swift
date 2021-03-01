//
//  StoreButton.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

final class StoreButton: UIButton {
    
    
    // MARK: - Override and Initialiser
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(fontSize: CGFloat, label: String) {
        self.init(frame: .zero)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        setTitle(label, for: .normal)
    }
    
    
    // MARK: - Configuration
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor     = UIColor(named: colorAsString.storeSecondary)
        layer.cornerRadius  = 10
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
    }
}
