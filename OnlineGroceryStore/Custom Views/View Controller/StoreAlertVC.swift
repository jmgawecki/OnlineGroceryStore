//
//  StoreAlertVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 01/03/2021.
//

import UIKit


    // MARK: - Protocol & Delegate



final class StoreAlertVC: UIViewController {
    //MARK: - Declarations

    let containerView   = UIView()
    let titleLabel      = StoreTitleLabel(from: .center, alpha: 1)
    let messageLabel    = StoreSecondaryTitleLabel(from: .left, alpha: 1)
    let actionButton    = StoreVCButton()
    var girlImageView   = ShopImageView(frame: .zero)
    
    var alertTitle:     String?
    var message:        String?
    var buttonTitle:    String?
    var girlImage:      UIImage?
    
    let padding:        CGFloat = 20
    
    
    //MARK: - Initialisers
    
    
    init(title: AlertTitle, message: AlertMessages, buttonTitle: AlertButtonTitle, image: AlertImage) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = title.rawValue
        self.message        = message.rawValue
        self.buttonTitle    = buttonTitle.rawValue
        self.girlImage      = image.rawValue
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layoutUI()
        configureUIElements()
    }
    
    
    //MARK: - Objectives
    
    
    @objc func dismissVC(sender: UIView) {
        animateButtonView(sender)
        dismiss(animated: true)
    }
    
    
    //MARK: - Layout configurations
    
    
    private func configure() { view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75) }
    
    
    private func configureUIElements() {
        view.backgroundColor                = UIColor.black.withAlphaComponent(0.75)
                
        titleLabel.textColor                = StoreUIColor.mint
        titleLabel.text                     = alertTitle ?? "Something went wrong"
                
        messageLabel.textColor              = StoreUIColor.mint
        messageLabel.text                   = message ?? "Unable to complete request"
        messageLabel.numberOfLines          = 4
                
        girlImageView.image                 = girlImage
        
        actionButton.backgroundColor        = StoreUIColor.black
        actionButton.setTitleColor(StoreUIColor.mint, for: .normal)
        
        containerView.backgroundColor       = StoreUIColor.grapefruit
        containerView.layer.cornerRadius    = 10

        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }


    private func layoutUI() {
        view.addSubviews(containerView, actionButton, titleLabel, messageLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint  (equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint  (equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint    (equalToConstant: 280),
            containerView.heightAnchor.constraint   (equalToConstant: 220),

            titleLabel.topAnchor.constraint         (equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint     (equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint    (equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint      (equalToConstant: 28),

            actionButton.bottomAnchor.constraint    (equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint   (equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint  (equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint    (equalToConstant: 44),

            messageLabel.topAnchor.constraint       (equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint   (equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint  (equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint    (equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    
    // MARK: - Animation
    
    
    private func animateButtonView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.1, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.1, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
}
