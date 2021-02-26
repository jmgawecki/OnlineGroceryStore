//
//  FavoritesCollectionViewCell.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    // MARK: - Declaration
    static let reuseId = "SpeicificCellName"
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Called Outside
    
    
    func set() {
        
    }
    
    
    // MARK: - Cell configuration
    
    
    private func configureCell() {
        backgroundColor                     = .systemBackground
        layer.cornerRadius                  = 15
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        
    }
}
