//
//  StoreImageLabelButton.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class StoreImageLabelButton: UIButton {
    // MARK: - Declaration
    
    var buttonImageView = ShopImageView(frame: .zero)
    var buttonLabel: StoreBoldLabel!
    
    
    // MARK: - Override and Initialiser
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fontSize: CGFloat, message: String, image: UIImage, textColor: UIColor) {
        super.init(frame: .zero)
        
        buttonLabel = StoreBoldLabel(with: message,
                               from: .left,
                               ofsize: fontSize,
                               ofweight: .medium,
                               alpha: 1,
                               color: textColor)
        configure()
        layoutUI()
    }
    
    
    // MARK: - Configuration
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor     = StoreUIColor.orange
        layer.cornerRadius  = 10
        layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius  = 0.0
        layer.masksToBounds = false
    }
    
    
    private func layoutUI() {
        addSubview(buttonImageView)
        addSubview(buttonLabel)
        buttonImageView.image = storeUIImage.foodPlaceholder
        
        
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint            (equalTo: topAnchor, constant: 5),
            buttonLabel.bottomAnchor.constraint         (equalTo: bottomAnchor, constant: -5),
            buttonLabel.centerXAnchor.constraint        (equalTo: centerXAnchor, constant: 10),
            buttonLabel.widthAnchor.constraint          (equalToConstant: 200),
            
            buttonImageView.topAnchor.constraint        (equalTo: topAnchor, constant: 5),
            buttonImageView.bottomAnchor.constraint     (equalTo: bottomAnchor, constant: -5),
            buttonImageView.trailingAnchor.constraint   (equalTo: buttonLabel.leadingAnchor, constant: -10),
            buttonImageView.widthAnchor.constraint      (lessThanOrEqualTo: heightAnchor, multiplier: 1.33, constant: -10),
        ])
    }
}
