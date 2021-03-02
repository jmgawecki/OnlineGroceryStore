//
//  ProductDetailsVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class ProductDetailsVC: UIViewController {
    // MARK: - Declaration
    
    var productImageView    = ShopImageView(frame: .zero)
    var productTitleLabel   = StoreBoldLabel(with: "Product's Name",
                                             from: .center,
                                             ofsize: 20,
                                             ofweight: .medium,
                                             alpha: 1,
                                             color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    
    var descriptionTextView = GroceryTextView(with: "Product's Description")
    var currentUser: UserLocal!
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        addSubviews(productImageView, productTitleLabel, descriptionTextView)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint       (equalTo: view.topAnchor, constant: -20),
            productImageView.leadingAnchor.constraint   (equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint  (equalTo: view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint    (equalToConstant: 250),
            
            productTitleLabel.topAnchor.constraint      (equalTo: productImageView.bottomAnchor, constant: 10),
            productTitleLabel.leadingAnchor.constraint  (equalTo: view.leadingAnchor, constant: 20),
            productTitleLabel.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -20),
            productTitleLabel.heightAnchor.constraint   (equalToConstant: 30),
            
            descriptionTextView.topAnchor.constraint      (equalTo: productTitleLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint  (equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint   (equalToConstant: 100)
        ])
    }
}


//MARK: - Extension

