//
//  EntryVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit

final class EntryVC: UIViewController {
//    var coordinator: Coordinator?
    
    // MARK: - Declaration
    var loginButton         = StoreVCButton(fontSize: 18, label: "Log In")
    var registerButton      = StoreVCButton(fontSize: 18, label: "Sign Up")
    
    var shopImageView       = ShopImageView(frame: .zero)
    var buttonsStack        = UIStackView()
    
    var welcomeLabel        = StoreBoldLabel(with: "Hi there",
                                             from: .left,
                                             ofsize: 35,
                                             ofweight: .bold,
                                             alpha: 0,
                                             color: StoreUIColor.grapefruit ?? .orange)

    
    var bodyLabel           = StoreSecondaryTitleLabel(from: .left, alpha: 0)
    
    var colorBottomView     = UIView()
    
    
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        configureUIElements()
        configureButtonsStackView()
        configureLoginButton()
        configureRegisterButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureVC()
        StoreAnimation.animateEntryVC(firstLabel: welcomeLabel, secondLabel: bodyLabel, logInPannel: colorBottomView, buttonsStack)
    }
    
    
    // MARK: - @Objectives
    
    
    @objc private func loginButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        let destVC = LogInVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        let destVC = SignUpVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    // MARK: - UI Configuration
    
    
    private func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureRegisterButton() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - UI Layout Configuration
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.isNavigationBarHidden = true
    }
    
    
    private func configureButtonsStackView() {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis                = .vertical
        buttonsStack.distribution        = .fillEqually
        buttonsStack.spacing             = 15
        buttonsStack.backgroundColor     = StoreUIColor.grapefruit
        buttonsStack.alpha               = 0
        
        loginButton.backgroundColor      = StoreUIColor.creamWhite
        loginButton.setTitleColor(StoreUIColor.black, for: .normal)
        
        registerButton.backgroundColor   = StoreUIColor.creamWhite
        registerButton.setTitleColor(StoreUIColor.black, for: .normal)
        
        buttonsStack.addArrangedSubview(loginButton)
        buttonsStack.addArrangedSubview(registerButton)
    }
    
    
    private func configureUIElements() {
        bodyLabel.text                          = "Please log in or sign up in order to buy some awesome things!"
        shopImageView.image                     = storeUIImage.shopBuilding
        
        colorBottomView.backgroundColor         = StoreUIColor.grapefruit
        colorBottomView.layer.cornerRadius      = 45
        colorBottomView.alpha                   = 0
    }
    
    
    private func layoutUIElements() {
        colorBottomView.translatesAutoresizingMaskIntoConstraints = false
    
        addSubviews(shopImageView, welcomeLabel, bodyLabel, colorBottomView)
        colorBottomView.addSubview(buttonsStack)
//        debugConfiguration(shopImageView,welcomeLabel,bodyLabel,colorBottomView,buttonsStack,colorBottomView)
        
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint          (equalTo: view.topAnchor, constant: 100),
            shopImageView.heightAnchor.constraint       (equalToConstant: 250),
            shopImageView.widthAnchor.constraint        (equalTo: shopImageView.heightAnchor, multiplier: 1.5),
            shopImageView.centerXAnchor.constraint      (equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint           (equalTo: shopImageView.bottomAnchor, constant: 10),
            welcomeLabel.widthAnchor.constraint         (equalToConstant: 250),
            welcomeLabel.heightAnchor.constraint        (equalToConstant: 45),
            welcomeLabel.leadingAnchor.constraint       (equalTo: shopImageView.leadingAnchor, constant: 15),
            
            bodyLabel.topAnchor.constraint              (equalTo: welcomeLabel.bottomAnchor),
            bodyLabel.widthAnchor.constraint            (equalToConstant: 310),
            bodyLabel.heightAnchor.constraint           (equalToConstant: 65),
            bodyLabel.leadingAnchor.constraint          (equalTo: shopImageView.leadingAnchor, constant: 15),
            
            buttonsStack.bottomAnchor.constraint        (equalTo: view.bottomAnchor, constant: -50),
            buttonsStack.heightAnchor.constraint        (equalToConstant: 100),
            buttonsStack.widthAnchor.constraint         (equalToConstant: 250),
            buttonsStack.centerXAnchor.constraint       (equalTo: view.centerXAnchor),
            
            colorBottomView.topAnchor.constraint        (equalTo: buttonsStack.topAnchor, constant: -50),
            colorBottomView.leadingAnchor.constraint    (equalTo: view.leadingAnchor, constant: 0),
            colorBottomView.trailingAnchor.constraint   (equalTo: view.trailingAnchor, constant: 40),
            colorBottomView.bottomAnchor.constraint     (equalTo: view.bottomAnchor, constant: 20),
        ])
    }
}
