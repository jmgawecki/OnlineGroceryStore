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
    var progressView:           OrderProgressUIView!
    var statusLabel             = StoreSecondaryTitleLabel(from: .center, alpha: 1)
    var totalPaidLable          = StoreBodyLabel(from: .left, alpha: 1)

    var currentUser:            UserLocal!
    var currentOrder:           Order!
    
    var seeOrderButton          = StoreVCButton(fontSize: 25, label: "See Order")
    
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        configureSeeOrderButton()
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
    
    
    @objc private func seeOrderButtonTapped(sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        let destVC = LastOrderVC(with: currentOrder, for: currentUser)
        destVC.lastOrderVCDelegates = self
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureSeeOrderButton() {
        seeOrderButton.addTarget(self, action: #selector(seeOrderButtonTapped), for: .touchUpInside)
    }
    
    
    private func updateTotalLabel() -> Double {
        var total = 0.0
        for product in currentOrder.products {
            total += (product.price * product.discountMlt) * Double(product.quantity)
        }
        return total
    }
    
    
    
    //MARK: - VC Configuration

    
    private func configureUIElements() {
        orderImageView.image = storeUIImage.pizzaDeliveryR32
        orderImageView.layer.cornerRadius = 0
        
        seeOrderButton.backgroundColor = StoreUIColor.grapefruit
        
        progressView = OrderProgressUIView(currentOrder: currentOrder)
        
        if currentOrder.status == "Processing" {
            statusLabel.text = currentOrder.status
        } else if currentOrder.status == "Out For Delivery" {
            statusLabel.text = "\(currentOrder.status)\nEst. delivery \(currentOrder.plannedDelivery ?? "unnknown yet")"
        } else if currentOrder.status == "Delivered" {
            statusLabel.text = "Delivered on \(currentOrder.delivered!)"
        }
        
        totalPaidLable.text = "Total paid: $\(String(format: "%.2f", updateTotalLabel()))"
        
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        progressView.translatesAutoresizingMaskIntoConstraints  = false
        
        addSubviews(orderImageView, progressView, statusLabel, seeOrderButton, totalPaidLable)
        
//        debugConfiguration(progressView, statusLabel, seeOrderButton, totalPaidLable)
        
        NSLayoutConstraint.activate([
            orderImageView.topAnchor.constraint         (equalTo: view.topAnchor, constant: 0),
            orderImageView.leadingAnchor.constraint     (equalTo: view.leadingAnchor, constant: 0),
            orderImageView.trailingAnchor.constraint    (equalTo: view.trailingAnchor, constant: 0),
            orderImageView.heightAnchor.constraint      (equalTo: orderImageView.widthAnchor, multiplier: 0.67),
            
            progressView.topAnchor.constraint           (equalTo: orderImageView.bottomAnchor, constant: 15),
            progressView.leadingAnchor.constraint       (equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint      (equalTo: view.trailingAnchor, constant: -30),
            progressView.heightAnchor.constraint        (equalToConstant: 5),
            
            statusLabel.topAnchor.constraint            (equalTo: progressView.bottomAnchor, constant: 15),
            statusLabel.centerXAnchor.constraint        (equalTo: view.centerXAnchor, constant: 0),
            statusLabel.widthAnchor.constraint          (equalToConstant: 250),
            statusLabel.heightAnchor.constraint         (equalToConstant: 60),
            
            totalPaidLable.topAnchor.constraint         (equalTo: statusLabel.bottomAnchor, constant: 0),
            totalPaidLable.leadingAnchor.constraint     (equalTo: statusLabel.leadingAnchor, constant: 0),
            totalPaidLable.trailingAnchor.constraint    (equalTo: statusLabel.trailingAnchor, constant: 0),
            totalPaidLable.heightAnchor.constraint      (equalToConstant: 30),
            
            seeOrderButton.bottomAnchor.constraint      (equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            seeOrderButton.centerXAnchor.constraint     (equalTo: view.centerXAnchor, constant: 0),
            seeOrderButton.widthAnchor.constraint       (equalToConstant: 230),
            seeOrderButton.heightAnchor.constraint      (equalToConstant: 44)
        ])
    }
    
    
}


//MARK: - Extension

extension OrderStatusVC: LastOrderVCDelegates {
    func didRequestDismissal() {
        self.presentStoreAlertOnMainThread(title: .success, message: .orderAddedToBasket, button: .ok, image: .happyBlackGirlR056)
    }
}
