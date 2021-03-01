//
//  FavoritesVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class FavoritesVC: UIViewController {
    // MARK: - Declaration
    
    
    
    
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
    }
    
    
    //MARK: - Layout configuration

    
    private func layoutUI() {
        
    }
    
    
}


    //MARK: - Extension
