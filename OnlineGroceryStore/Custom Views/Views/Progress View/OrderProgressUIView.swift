//
//  OrderProgressUIView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 10/03/2021.
//

import UIKit


enum OrderStatus: String {
    case processing         = "Processing"
    case outDelivery        = "Out For Delivery"
    case Delivered          = "Delivered"
}


class OrderProgressUIView: UIView {
    // MARK: - Declaration
    var progressView        = UIProgressView(progressViewStyle: .default)
    
    var processingView      = ProgressCircledView()
    var outDeliveryView     = ProgressCircledView()
    var deliveredView       = ProgressCircledView()
    
    var spacing1            = UIView()
    var spacing2            = UIView()
    
    var currentOrder:       Order!
    
    // MARK: - Override and Initialise
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIElements()
        layoutUIElements()
        configureDeliveryStatus(orderStatus: currentOrder.status)
    }
    
    
    init(currentOrder: Order) {
        super.init(frame: .zero)
        configureUIElements()
        layoutUIElements()
        configureDeliveryStatus(orderStatus: currentOrder.status)
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    
    
    
    // MARK: - UI Configuration
    
    private func configureView() {
        
        
        
    }
    
    
    private func configureUIElements() {
        progressView.progressTintColor      = StoreUIColor.grapefruit
    }
    

    private func configureDeliveryStatus(orderStatus: String) {
        let orderStatus = orderStatus
        if let status = OrderStatus(rawValue: orderStatus) {
            switch status {
            case .processing:
                processingView.alpha                = 0.85
                outDeliveryView.alpha               = 0
                deliveredView.alpha                 = 0
                progressView.progress               = 0.15
                processingView.backgroundColor      = StoreUIColor.grapefruit
                animateProgressCircle(progressCircle: processingView)
            case .outDelivery:
                processingView.alpha                = 1
                outDeliveryView.alpha               = 0.85
                deliveredView.alpha                 = 0
                progressView.progress               = 0.55
                processingView.backgroundColor      = StoreUIColor.grapefruit
                outDeliveryView.backgroundColor     = StoreUIColor.grapefruit
                animateProgressCircle(progressCircle: outDeliveryView)
            case .Delivered:
                processingView.alpha                = 1
                outDeliveryView.alpha               = 1
                deliveredView.alpha                 = 0.85
                progressView.progress               = 1
                processingView.backgroundColor      = StoreUIColor.grapefruit
                outDeliveryView.backgroundColor     = StoreUIColor.grapefruit
                deliveredView.backgroundColor       = StoreUIColor.grapefruit
                animateProgressCircle(progressCircle: deliveredView)
            }
        }
    }
    
    
    // MARK: - UI Layout Configuration
    
    private func layoutUIElements() {
        translatesAutoresizingMaskIntoConstraints               = false
        progressView.translatesAutoresizingMaskIntoConstraints  = false
        
        spacing1.translatesAutoresizingMaskIntoConstraints      = false
        spacing2.translatesAutoresizingMaskIntoConstraints      = false
        
        addSubviews(progressView, processingView, outDeliveryView, deliveredView, spacing1, spacing2)
        
//        debugConfiguration(spacing2)
        
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint       (equalTo: centerYAnchor, constant: 0),
            progressView.leadingAnchor.constraint       (equalTo: leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint      (equalTo: trailingAnchor, constant: 0),
            progressView.heightAnchor.constraint        (equalToConstant: 5),
            
            spacing1.centerYAnchor.constraint           (equalTo: centerYAnchor, constant: 0),
            spacing1.leadingAnchor.constraint           (equalTo: leadingAnchor, constant: 0),
            spacing1.widthAnchor.constraint             (equalTo: widthAnchor, multiplier: 0.15),
            spacing1.heightAnchor.constraint            (equalTo: heightAnchor, multiplier: 1),
            
            spacing2.centerYAnchor.constraint           (equalTo: centerYAnchor, constant: 0),
            spacing2.leadingAnchor.constraint           (equalTo: leadingAnchor, constant: 0),
            spacing2.widthAnchor.constraint             (equalTo: widthAnchor, multiplier: 0.55),
            spacing2.heightAnchor.constraint            (equalTo: heightAnchor, multiplier: 1),
            
            processingView.centerXAnchor.constraint     (equalTo: spacing1.trailingAnchor, constant: 0),
            processingView.centerYAnchor.constraint     (equalTo: progressView.centerYAnchor, constant: 0),
            processingView.widthAnchor.constraint       (equalToConstant: 15),
            processingView.heightAnchor.constraint      (equalTo: processingView.widthAnchor),
            
            outDeliveryView.centerXAnchor.constraint    (equalTo: spacing2.trailingAnchor, constant: 0),
            outDeliveryView.centerYAnchor.constraint    (equalTo: progressView.centerYAnchor, constant: 0),
            outDeliveryView.widthAnchor.constraint      (equalToConstant: 15),
            outDeliveryView.heightAnchor.constraint     (equalTo: processingView.widthAnchor),
            
            deliveredView.centerXAnchor.constraint      (equalTo: trailingAnchor, constant: 0),
            deliveredView.centerYAnchor.constraint      (equalTo: progressView.centerYAnchor, constant: 0),
            deliveredView.widthAnchor.constraint        (equalToConstant: 15),
            deliveredView.heightAnchor.constraint       (equalTo: processingView.widthAnchor),
            
            
        ])
    }
    
    
    // MARK: - Animation
    
    
    func animateProgressCircle(progressCircle: UIView) {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            progressCircle.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            progressCircle.alpha = 1
        } completion: { (_) in
            
        }

    }
}

