//
//  HomeVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit
import Firebase

final class HomeVC: UIViewController {
    // MARK: - Declaration
    
    var logOutButton            = StoreButton(fontSize: 18, label: "Log Out")
    var scrollView              = UIScrollView()
    var hiNameLabel             = StoreBoldLabel(with: "Hello ",
                                                 from: .left,
                                                 ofsize: 20,
                                                 ofweight: .bold,
                                                 alpha: 1,
                                                 color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    
    var currentUser: UserLocal?
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureLogOutButton()
        configureDeclarations()
        configureUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureVC()
    }
    
    
    private func getCurrentUserData() {
        let userEmail = (Auth.auth().currentUser?.email)!
        Firestore.firestore().collection("usersData").document(userEmail).getDocument(completion: { [weak self] (user, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                self.currentUser = UserLocal(uid:       user?.data()!["uid"]        as! String,
                                             firstName: user?.data()!["firstname"]  as! String,
                                             lastName:  user?.data()!["lastname"]   as! String,
                                             email:     user?.data()!["email"]      as! String)
                
                #warning("How to make it better? How to append name to a label before class is initialised. Tried in scene delegate but its a one big mess")
                DispatchQueue.main.async {
                    self.hiNameLabel.text?.append("\(self.currentUser!.firstName)")
                }
            }
        })
    }

    
    // MARK: - @Objectives
    
   
    @objc private func logOutButtonTapped() {
        var isError: Error? = nil
        do {
            try Auth.auth().signOut()
        } catch let error {
            isError = error
        }
        if isError == nil {
            let destVC = logOutVC()
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    private func configureDeclarations() {
      
    }
    
    
    private func configureLogOutButton() {
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(hiNameLabel)
        scrollView.addSubview(logOutButton)
        scrollView.backgroundColor = .systemRed
        scrollView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint             (equalTo: view.topAnchor),
            scrollView.heightAnchor.constraint          (equalToConstant: 1000),
            scrollView.leadingAnchor.constraint         (equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint        (equalTo: view.trailingAnchor),

            logOutButton.centerXAnchor.constraint       (equalTo: scrollView.centerXAnchor),
            logOutButton.topAnchor.constraint           (equalTo: scrollView.centerYAnchor),
            logOutButton.widthAnchor.constraint         (equalToConstant: 150),
            logOutButton.heightAnchor.constraint        (equalToConstant: 500),
            
            hiNameLabel.centerXAnchor.constraint        (equalTo: scrollView.centerXAnchor),
            hiNameLabel.topAnchor.constraint            (equalTo: logOutButton.bottomAnchor),
            hiNameLabel.widthAnchor.constraint          (equalToConstant: 150),
            hiNameLabel.heightAnchor.constraint         (equalToConstant: 500),
        ])
    }


}

