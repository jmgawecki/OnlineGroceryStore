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
    // MARK: - Coordinator
    
//    var coordinator: Coordinator?
    
    // MARK: - Declaration
    
    var scrollView              = UIScrollView()
    
    
    var hiNameLabel             = StoreTitleLabel(from: .left, alpha: 0)
//    var vawingGirlImageView     = ShopImageView(frame: .zero)
    
    var colorTopView            = UIView()
    
    var contentView             = UIView()
    var specialOffersView       = UIView()
    var favoritesOffersView     = UIView()
    
    var allCategoriesButton     = StoreVCButton(fontSize: 20, label: "Shop by Category")
    
    var logOutButton         = StoreVCButton(fontSize: 18, label: "Log Out")
    
    var currentUser:            UserLocal?
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutAndConfigureScrollView()
        configureUIElements()
        layoutUIInScrollView()
        configureButtons()
        animateViews()
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
        
//        coordinator?.pushVCWithUser(with: currentUser, viewController: , isNavigationHidden: <#T##Bool#>)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    @objc private func logOutButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        signOut()
    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureVC() {
        StoreAnimation.animateTabBar(viewToAnimate: tabBarController!.tabBar, tabBarAnimationPath: .fromOrder)
        view.backgroundColor = StoreUIColor.creamWhite
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
    
    
    private func configureButtons() {
        allCategoriesButton.addTarget(self, action: #selector(allCategoriesButtonTapped), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
    }
    
    
    private func animateViews() {
        StoreAnimation.animateViewToAppear(hiNameLabel, animationDuration: 1, animationDelay: 0.5)
    }
    
    
    // MARK: - UI Configuration

    
    private func configureUIElements() {
        hiNameLabel.text                            = "Hi \(currentUser?.firstName ?? "")"
        hiNameLabel.textColor                       = StoreUIColor.creamWhite
        hiNameLabel.font                            = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        scrollView.backgroundColor                  = StoreUIColor.scrollViewBackground
        
        colorTopView.backgroundColor                = StoreUIColor.creamWhite
        colorTopView.layer.cornerRadius             = 45
        
        allCategoriesButton.backgroundColor         = StoreUIColor.creamWhite
        allCategoriesButton.setTitleColor(StoreUIColor.black, for: .normal)
        
        logOutButton.backgroundColor                = StoreUIColor.grapefruit
        logOutButton.setTitleColor(.white, for: .normal)
        
        hiNameLabel.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        
       
    }
    
    
    //MARK: - Layout UI
    
    
    private func layoutAndConfigureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        contentView.translatesAutoresizingMaskIntoConstraints   = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
            contentView.heightAnchor.constraint             (equalToConstant: 965),
        ])
    }
    
    
    private func layoutUIInScrollView() {
        specialOffersView.translatesAutoresizingMaskIntoConstraints     = false
        favoritesOffersView.translatesAutoresizingMaskIntoConstraints   = false
        colorTopView.translatesAutoresizingMaskIntoConstraints          = false
        
        contentView.addSubviews(hiNameLabel, allCategoriesButton, colorTopView, logOutButton)
        colorTopView.addSubviews(favoritesOffersView, specialOffersView)
        
        add(childVC: SpecialOffersView(currentUser: currentUser!, specialOffersViewDelegate: self), to: specialOffersView)
        add(childVC: LastsVC(currentUser: currentUser!, lastsVCDelegates: self), to: favoritesOffersView)
        
        
        NSLayoutConstraint.activate([
            hiNameLabel.leadingAnchor.constraint            (equalTo: contentView.leadingAnchor, constant: 30),
            hiNameLabel.topAnchor.constraint                (equalTo: contentView.topAnchor, constant: 10),
            hiNameLabel.widthAnchor.constraint              (equalToConstant: 220),
            hiNameLabel.heightAnchor.constraint             (equalToConstant: 50),
   
            allCategoriesButton.topAnchor.constraint        (equalTo: hiNameLabel.bottomAnchor, constant: 15),
            allCategoriesButton.leadingAnchor.constraint    (equalTo: hiNameLabel.leadingAnchor, constant: 0),
            allCategoriesButton.widthAnchor.constraint      (equalToConstant: 250),
            allCategoriesButton.heightAnchor.constraint     (equalToConstant: 44),
            
            favoritesOffersView.topAnchor.constraint        (equalTo: allCategoriesButton.bottomAnchor, constant: 70),
            favoritesOffersView.leadingAnchor.constraint    (equalTo: contentView.leadingAnchor, constant: 0),
            favoritesOffersView.trailingAnchor.constraint   (equalTo: contentView.trailingAnchor, constant: 0),
            favoritesOffersView.heightAnchor.constraint     (equalToConstant: 300),
            
            specialOffersView.topAnchor.constraint          (equalTo: favoritesOffersView.bottomAnchor, constant: 20),
            specialOffersView.leadingAnchor.constraint      (equalTo: contentView.leadingAnchor, constant: 0),
            specialOffersView.trailingAnchor.constraint     (equalTo: contentView.trailingAnchor, constant: 0),
            specialOffersView.heightAnchor.constraint       (equalToConstant: 330),
            
            logOutButton.topAnchor.constraint               (equalTo: specialOffersView.bottomAnchor, constant: 0),
            logOutButton.leadingAnchor.constraint           (equalTo: contentView.leadingAnchor, constant: 15),
            logOutButton.trailingAnchor.constraint          (equalTo: contentView.trailingAnchor, constant: -15),
            logOutButton.heightAnchor.constraint            (equalToConstant: 44),
            
            colorTopView.topAnchor.constraint               (equalTo: favoritesOffersView.topAnchor, constant: -30),
            colorTopView.leadingAnchor.constraint           (equalTo: contentView.leadingAnchor, constant: 0),
            colorTopView.trailingAnchor.constraint          (equalTo: contentView.trailingAnchor, constant: 50),
            colorTopView.bottomAnchor.constraint            (equalTo: contentView.bottomAnchor, constant: 300),
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
