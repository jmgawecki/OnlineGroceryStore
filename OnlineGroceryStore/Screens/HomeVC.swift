//
//  HomeVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit
import Firebase

final class HomeVC: UIViewController {

    var logOutButton         = StoreButton(fontSize: 18, label: "Log Out")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        configureLogOutButton()
    }
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
    }
    
    private func configureLogOutButton() {
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logOutButtonTapped() {
        var isError: Error? = nil
        do {
            try Auth.auth().signOut()
        } catch let error {
            isError = error
        }
        if isError == nil {
            let destVC = HomeVC()
            view.window?.rootViewController = destVC
            view.window?.makeKeyAndVisible()
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    private func configureUIElements() {
        addSubviews(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 150),
            logOutButton.heightAnchor.constraint(equalToConstant: 150),
        ])
    }


}

