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
    
    var scrollView              = UIScrollView()
    
    var logOutButton            = StoreButton(fontSize: 18, label: "Log Out")
    var hiNameLabel             = StoreBoldLabel(with: "Hello ",
                                                 from: .left,
                                                 ofsize: 30,
                                                 ofweight: .bold,
                                                 alpha: 0,
                                                 color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    var vawingGirlImageView         = ShopImageView(frame: .zero)
    
    var contentView             = UIView()
    var specialOffersView   = UIView()
    var favoritesOffersView = UIView()
    
    var allCategoriesButton = StoreImageLabelButton(fontSize: 20, message: "Shop by Category", image: imageAsUIImage.foodPlaceholder!, textColor: UIColor(named: colorAsString.storeTertiary) ?? .green)
    
    var currentUser: UserLocal?
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutAndConfigureScrollView()
        layoutUIInScrollView()
        configureLogOutButton()
        configureAllCategoriesButton()
        configureUIElements()
        getCurrentUser()
        animateViews()
        add(childVC: SpecialOffersView(currentUser: currentUser!), to: specialOffersView)
        add(childVC: FavoritesView(currentUser: currentUser!), to: favoritesOffersView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureVC()
    }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
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
    
    
    @objc private func allCategoriesButtonTapped(_ sender: UIView) {
        animateButtonViewAlpha(sender)
        let destVC = CategoriesVC(currentUser: currentUser!)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        vawingGirlImageView.image = imageAsUIImage.wavingBlackGirlR056
        vawingGirlImageView.alpha = 0
    }
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    // MARK: - Button Configuration
    
    
    private func configureLogOutButton() { logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside) }
    
    
    private func configureAllCategoriesButton() { allCategoriesButton.addTarget(self, action: #selector(allCategoriesButtonTapped), for: .touchUpInside) }
    
    
    private func animateViews() {
        animateViewAlpha(hiNameLabel)
        animateViewAlpha(vawingGirlImageView)
    }
    
    
    //MARK: - Firebase
    
    
    func getCurrentUser() {
        FireManager.shared.getCurrentUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                self.currentUser = currentUser
                DispatchQueue.main.async { self.hiNameLabel.text = "Hi \(currentUser.firstName)" }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - Layout UI
    
    
    private func layoutAndConfigureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        contentView.translatesAutoresizingMaskIntoConstraints   = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint             (equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint          (equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint         (equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint        (equalTo: view.trailingAnchor),
        
            contentView.topAnchor.constraint            (equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint         (equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint        (equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint       (equalTo: scrollView.trailingAnchor),
        
            contentView.widthAnchor.constraint          (equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint         (equalToConstant: 1400),
        ])
    }
    
    
    private func layoutUIInScrollView() {
        contentView.addSubviews(hiNameLabel, vawingGirlImageView, favoritesOffersView, specialOffersView, allCategoriesButton, logOutButton)
        //        debugConfiguration(hiNameLabel, vawingGirlImageView, favoritesView, specialOffersView, allCategoriesButton)
        specialOffersView.translatesAutoresizingMaskIntoConstraints     = false
        favoritesOffersView.translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
            hiNameLabel.leadingAnchor.constraint            (equalTo: contentView.leadingAnchor, constant: 30),
            hiNameLabel.topAnchor.constraint                (equalTo: contentView.topAnchor, constant: 20),
            hiNameLabel.widthAnchor.constraint              (equalToConstant: 220),
            hiNameLabel.heightAnchor.constraint             (equalToConstant: 50),
            
            vawingGirlImageView.topAnchor.constraint        (equalTo: contentView.topAnchor),
            vawingGirlImageView.leadingAnchor.constraint    (equalTo: hiNameLabel.trailingAnchor, constant: 5), //
            vawingGirlImageView.widthAnchor.constraint      (equalToConstant: 100),
            vawingGirlImageView.heightAnchor.constraint     (equalTo: vawingGirlImageView.widthAnchor, multiplier: 1.78),
            
            favoritesOffersView.topAnchor.constraint        (equalTo: vawingGirlImageView.bottomAnchor),
            favoritesOffersView.leadingAnchor.constraint    (equalTo: contentView.leadingAnchor, constant: 0),
            favoritesOffersView.trailingAnchor.constraint   (equalTo: contentView.trailingAnchor, constant: 0),
            favoritesOffersView.heightAnchor.constraint     (equalToConstant: 355),
            
            specialOffersView.topAnchor.constraint          (equalTo: favoritesOffersView.bottomAnchor, constant: 20),
            specialOffersView.leadingAnchor.constraint      (equalTo: contentView.leadingAnchor, constant: 0),
            specialOffersView.trailingAnchor.constraint     (equalTo: contentView.trailingAnchor, constant: 0),
            specialOffersView.heightAnchor.constraint       (equalToConstant: 355),
            
            allCategoriesButton.topAnchor.constraint        (equalTo: specialOffersView.bottomAnchor, constant: 10),
            allCategoriesButton.leadingAnchor.constraint    (equalTo: contentView.leadingAnchor, constant: 10),
            allCategoriesButton.trailingAnchor.constraint   (equalTo: contentView.trailingAnchor, constant: -10),
            allCategoriesButton.heightAnchor.constraint     (equalToConstant: 60),
        ])
    }
    
    
    // MARK: - Animation
    
    
    private func animateViewAlpha(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 1, delay: 0.5) {
            viewToAnimate.alpha = 1
        }
    }
    
    
    private func animateButtonViewAlpha(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
}
