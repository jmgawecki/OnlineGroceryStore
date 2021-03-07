//
//  HomeVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit
import Firebase
import Network

final class HomeVC: UIViewController {
    // MARK: - Declaration
    
    var scrollView              = UIScrollView()
    
    var quickActionMenu:        StoreVCButton!
    var hiNameLabel             = StoreTitleLabel(from: .left, alpha: 0)
    var vawingGirlImageView     = ShopImageView(frame: .zero)
    
    var contentView             = UIView()
    var specialOffersView       = UIView()
    var favoritesOffersView     = UIView()
    
    var allCategoriesButton     = StoreImageLabelButton(fontSize: 20,
                                                        message: "Shop by Category",
                                                        image: imageAsUIImage.foodPlaceholder!,
                                                        textColor: colorAsUIColor.storeTertiary ?? .green)
    
    var currentUser:            UserLocal?
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetworkStatus()
        layoutAndConfigureScrollView()
        configureQuickActionMenu()
        layoutUIInScrollView()
        configureAllCategoriesButton()
        configureUIElements()
        animateViews()
        add(childVC: SpecialOffersView(currentUser: currentUser!, specialOffersViewDelegate: self), to: specialOffersView)
        add(childVC: LastsVC(currentUser: currentUser!, lastsVCDelegates: self), to: favoritesOffersView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) { configureVC() }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func allCategoriesButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        let destVC = CategoriesVC(currentUser: currentUser!)
        checkNetworkStatus()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureVC() {
        view.backgroundColor = colorAsUIColor.storeBackground
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //MARK: - Private Function
    
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    // MARK: - Network Manager
    
    
    func checkNetworkStatus() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("internet")
            }
            else {
                print("no internet")
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
    }
    
    
    //MARK: - Firebase

    
    private func signOut() {
        var isError: Error? = nil
        do {
            try Auth.auth().signOut()
        } catch let error {
            isError = error
            presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .sadBlackGirlR056)
        }
        if isError == nil {
            let destVC = logOutVC()
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    
    // MARK: - Button Configuration
    
    
    private func configureAllCategoriesButton() {
        allCategoriesButton.addTarget(self, action: #selector(allCategoriesButtonTapped), for: .touchUpInside)
    }
    
    
    private func animateViews() {
        StoreAnimation.animateViewToAppear(hiNameLabel, animationDuration: 1, animationDelay: 0.5)
        StoreAnimation.animateViewToAppear(vawingGirlImageView, animationDuration: 1, animationDelay: 0.5)
    }
    
    
    // MARK: - UI Configuration
    
    
    private func configureQuickActionMenu() {
        quickActionMenu             = StoreVCButton(fontSize: 18, label: "More")
        quickActionMenu.menu        = UIMenu(options: .displayInline,
                                             children: [ UIAction(title: "Log out", handler: { [weak self] (_) in
                                                guard let self = self else { return }
                                                self.signOut()
                                             }),
                                             UIAction(title: "Personal data", handler: { (_) in
                                                print("tralalallalalalaa")
                                             })])
        quickActionMenu.showsMenuAsPrimaryAction = true
    }
    
    
    private func configureUIElements() {
        vawingGirlImageView.image   = imageAsUIImage.wavingBlackGirlR056
        vawingGirlImageView.alpha   = 0
        hiNameLabel.text            = "Hi \(currentUser?.firstName ?? "")"
    }
    
    
    //MARK: - Layout UI
    
    
    private func layoutAndConfigureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        contentView.translatesAutoresizingMaskIntoConstraints   = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.backgroundColor = colorAsUIColor.storeBackground
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint                 (equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint              (equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint             (equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint            (equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint                (equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint             (equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint            (equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint           (equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint              (equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint             (equalToConstant: 1000),
        ])
    }
    
    
    private func layoutUIInScrollView() {
        contentView.addSubviews(hiNameLabel, quickActionMenu ,vawingGirlImageView, favoritesOffersView, specialOffersView, allCategoriesButton)
        specialOffersView.translatesAutoresizingMaskIntoConstraints     = false
        favoritesOffersView.translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
            hiNameLabel.leadingAnchor.constraint            (equalTo: contentView.leadingAnchor, constant: 30),
            hiNameLabel.topAnchor.constraint                (equalTo: contentView.topAnchor, constant: 20),
            hiNameLabel.widthAnchor.constraint              (equalToConstant: 220),
            hiNameLabel.heightAnchor.constraint             (equalToConstant: 50),
            
            quickActionMenu.topAnchor.constraint            (equalTo: hiNameLabel.bottomAnchor, constant: 0),
            quickActionMenu.leadingAnchor.constraint        (equalTo: hiNameLabel.leadingAnchor, constant: 10),
            quickActionMenu.widthAnchor.constraint          (equalToConstant: 140),
            quickActionMenu.heightAnchor.constraint         (equalToConstant: 44),
            
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
}


    // MARK: - Extension


extension HomeVC: SpecialOffersViewDelegate {
    func productDetailsRequestedDismissal() {
        presentStoreAlertOnMainThread(title: .success, message: .itemAddedToBasket, button: .ok, image: .happyBlackGirlR056)
    }
}


extension HomeVC: LastsVCDelegates {
    func productDetailsRequestedDismissalThroughLasts() {
        presentStoreAlertOnMainThread(title: .success, message: .itemAddedToBasket, button: .ok, image: .happyBlackGirlR056)
    }
}
