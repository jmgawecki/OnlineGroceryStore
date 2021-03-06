//
//  GroceryTextView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class GroceryTextView: UITextView {
    // MARK: - Declaration
    
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with text: String) {
        super.init(frame: .zero, textContainer: .none)
        configure()
        self.text = text
    }
    
    // MARK: - Configuration
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        font                                        = UIFont.systemFont(ofSize: 17)
        isEditable                                  = false
        backgroundColor                             = colorAsUIColor.storeBackground
        textColor                                   = colorAsUIColor.storePrimaryText
    }
}
