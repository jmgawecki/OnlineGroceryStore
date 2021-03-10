//
//  OrderProgressUIView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 10/03/2021.
//

import UIKit

class OrderProgressUIView: UIView {
    // MARK: - Declaration
    var progressView        = UIProgressView(progressViewStyle: .default)
    
    var processingView      = ProgressCircledView()
    var outDeliveryView     = ProgressCircledView()
    var deliveredView       = ProgressCircledView()
    
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    
    // MARK: - UI Configuration
    
    private func configureView() {
        
        
        
    }
    
    
    private func configureUIElements() {
        progressView.progress               = 0.25
        progressView.progressTintColor      = StoreUIColor.grapefruit
    }
    
    
    
    
    // MARK: - UI Layout Configuration
    
    private func layoutUIElements() {
        
    }
    
    
}

