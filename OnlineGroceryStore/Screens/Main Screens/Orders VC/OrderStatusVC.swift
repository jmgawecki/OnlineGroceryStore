//
//  OrderStatusVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 10/03/2021.
//

import UIKit

class OrderStatusVC: UIViewController {
    // MARK: - Declaration
    
    var orderImageView          = ShopImageView(frame: .zero)
    var progressView            = UIProgressView(progressViewStyle: .default)
    var firstPoint              = ProgressCircledView()
    var secondPoint             = UIView()
    var thirdPoint              = UIView()
    
    var currentUser:            UserLocal!
    var currentOrder:           Order!
    
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        configureProgressView()
        layoutUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        StoreAnimation.animateTabBar(viewToAnimate: tabBarController!.tabBar, tabBarAnimationPath: .fromOrder)
    }
    
    
    init(currentUser: UserLocal, currentOrder: Order) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser        = currentUser
        self.currentOrder       = currentOrder
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - VC Configuration
    
    private func configureProgressView() {
        progressView.progress               = 0.25
        progressView.progressTintColor      = StoreUIColor.grapefruit
        
        secondPoint.backgroundColor         = StoreUIColor.grapefruit
        thirdPoint.backgroundColor          = StoreUIColor.grapefruit
    }
    
    
    private func configureUIElements() {
        orderImageView.image = storeUIImage.pizzaDeliveryR32
        orderImageView.layer.cornerRadius = 0
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        progressView.translatesAutoresizingMaskIntoConstraints  = false
        secondPoint.translatesAutoresizingMaskIntoConstraints   = false
        thirdPoint.translatesAutoresizingMaskIntoConstraints    = false
        
        addSubviews(orderImageView, progressView, firstPoint, secondPoint, thirdPoint)
        
        NSLayoutConstraint.activate([
            orderImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            orderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            orderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            orderImageView.heightAnchor.constraint(equalTo: orderImageView.widthAnchor, multiplier: 0.67),
            
            progressView.topAnchor.constraint(equalTo: orderImageView.bottomAnchor, constant: 15),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            progressView.heightAnchor.constraint(equalToConstant: 5),
            
            firstPoint.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: 0),
            firstPoint.centerXAnchor.constraint(equalTo: progressView.centerXAnchor, constant: 0),
            firstPoint.heightAnchor.constraint(equalToConstant: 13),
            firstPoint.widthAnchor.constraint(equalToConstant: 13),
        ])
    }
    
    
}


//MARK: - Extension

