//
//  LastOrderVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 03/03/2021.
//

import UIKit


// MARK: - Protocol & Delegate


protocol LastOrderVCDelegates: class {
    func didRequestDismissal()
}

class LastOrderVC: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    var collectionView:         UICollectionView!
    var dataSource:             UICollectionViewDiffableDataSource<Section, ProductLocal>!
    
    var totalLabel              = StoreSecondaryTitleLabel(from: .right, alpha: 1)
    var addToBasketButton       = StoreVCButton(fontSize: 20, label: "Add to basket")
    
    var currentUser:            UserLocal!
    var order:                  Order!
    
    var bottomColorView         = UIView()
    
    weak var lastOrderVCDelegates: LastOrderVCDelegates!
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureUIElements()
        layoutUI()
        configureDataSource()
        updateDataOnCollection()
        configureAddToBasketButton()
        updateTotalLabel()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { FireManager.shared.clearCache() }
    
    
    override func viewWillAppear(_ animated: Bool) {
        StoreAnimation.animateTabBar(viewToAnimate: tabBarController!.tabBar, tabBarAnimationPath: .toOrder)
    }
    
    
    init(with order: Order, for currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
        self.order = order
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func addToBasketButtonTapped(sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        addOrderToBasket()
    }
    
    
    // MARK: - Firebase
    
    
    private func addOrderToBasket() {
        FireManager.shared.addOrderToBasket(for: currentUser, order: order) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .none:
                print("success")
                self.lastOrderVCDelegates.didRequestDismissal()
                _ = self.navigationController?.popViewController(animated: true)
            case .some(let error):
                print(error)
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .concernedBlackGirlR056)
            }
        }
    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Button Configuration
    
    
    private func configureAddToBasketButton() { addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside) }
    
    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionLayouts.basketCollectionViewLayout())
        collectionView.backgroundColor = StoreUIColor.creamWhite
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BasketCollectionViewCell, ProductLocal> { (cell, indexPath, product) in
            cell.set(with: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> BasketCollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    
    private func updateDataOnCollection() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductLocal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(order.products, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true); self.collectionView.reloadData() }
        
    }
    
    // MARK: - UI Configuration
    
    
    private func configureUIElements() {
        addToBasketButton.setTitleColor(StoreUIColor.grapefruit, for: .normal)
        addToBasketButton.backgroundColor       = StoreUIColor.black
        bottomColorView.backgroundColor         = StoreUIColor.grapefruit
        bottomColorView.layer.cornerRadius      = 44
            
        totalLabel.layer.cornerRadius           = 10
        totalLabel.textColor                    = .white
        totalLabel.backgroundColor              = StoreUIColor.grapefruit
    }
    
    private func updateTotalLabel() {
        var total = 0.0
        for product in order.products {
            print(product)
            total += (product.price * product.discountMlt) * Double(product.quantity)
            print(total)
        }
        print(total)
        DispatchQueue.main.async {
            self.totalLabel.text = "Paid Total: $\(String(format: "%.2f", total))"
        }
    }
    
    
    
    //MARK: - Layout UI
    
    
    private func layoutUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints    = false
        bottomColorView.translatesAutoresizingMaskIntoConstraints   = false
        addSubviews(bottomColorView, collectionView)
        bottomColorView.addSubviews(addToBasketButton, totalLabel)
        //        debugConfiguration(bottomColorView, collectionView, orderButton, totalLabel)
        
        NSLayoutConstraint.activate([
            addToBasketButton.bottomAnchor.constraint       (equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3),
            addToBasketButton.leadingAnchor.constraint      (equalTo: view.leadingAnchor, constant: 20),
            addToBasketButton.trailingAnchor.constraint     (equalTo: view.trailingAnchor, constant: -20),
            addToBasketButton.heightAnchor.constraint       (equalToConstant: 44),
            
            totalLabel.bottomAnchor.constraint              (equalTo: addToBasketButton.topAnchor, constant: -10),
            totalLabel.trailingAnchor.constraint            (equalTo: addToBasketButton.trailingAnchor, constant: 0),
            totalLabel.widthAnchor.constraint               (equalToConstant: 250),
            totalLabel.heightAnchor.constraint              (equalToConstant: 40),
            
            collectionView.topAnchor.constraint             (equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint         (equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint        (equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint          (equalTo: addToBasketButton.topAnchor, constant: -50),
            
            bottomColorView.bottomAnchor.constraint         (equalTo: view.bottomAnchor, constant: 50),
            bottomColorView.leadingAnchor.constraint        (equalTo: view.leadingAnchor, constant: 0),
            bottomColorView.trailingAnchor.constraint       (equalTo: view.trailingAnchor, constant: 50),
            bottomColorView.topAnchor.constraint            (equalTo: collectionView.bottomAnchor, constant: 0),
        ])
    }
    
    
}
