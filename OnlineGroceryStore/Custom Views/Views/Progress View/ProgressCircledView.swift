//
//  progressCircledPointView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 10/03/2021.
//

import UIKit

class ProgressCircledView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    override func layoutSubviews() {
        layer.cornerRadius                          = bounds.height / 2
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        backgroundColor                             = .gray
        alpha                                       = 0.3
    }
}
