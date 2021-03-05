//
//  LastOrderVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 03/03/2021.
//

import UIKit

class LastOrderVC: UIViewController {
    // MARK: - Declaration
    
    var order: Order!
    
    enum Section { case main }
    
    var collectionView:     UICollectionView!
    var dataSource:         UICollectionViewDiffableDataSource<Section, ProductLocal>!
    var currentUser:        UserLocal!
    
    
    var addToBasketButton = StoreImageLabelButton(fontSize: 20, message: "Add to Basket", image: imageAsUIImage.foodPlaceholder!, textColor: UIColor(named: colorAsString.storeTertiary) ?? .green)
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        configureCollectionView()
        layoutUI()
        configureDataSource()
        updateDataOnCollection()
        configureAddToBasketButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireManager.shared.clearCache()
    }
    
    init(with order: Order) {
        super.init(nibName: nil, bundle: nil)
        self.order = order
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @Objectives
    
    
    @objc private func addToBasketButtonTapped(sender: UIView) {
        animateButtonView(sender)
        addOrderToBasket()
    }
    
    
    // MARK: - Firebase
    
    private func addOrderToBasket() {
        #warning("do a check on current user")
        FireManager.shared.addOrderToBasket(for: currentUser, order: order) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    // MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureAddToBasketButton() {
        addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
    }
    
    
    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionLayouts.productsVCCollectionViewLayout())
//        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: colorAsString.storeBackground)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<LastOrderVCCollectionViewCell, ProductLocal> { (cell, indexPath, product) in
            cell.set(with: product, currentUser: self.currentUser)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> LastOrderVCCollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    private func updateDataOnCollection() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductLocal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(order.products, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true); self.collectionView.reloadData() }
        
    }
    
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        view.addSubviews(addToBasketButton ,collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToBasketButton.bottomAnchor.constraint   (equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            addToBasketButton.leadingAnchor.constraint  (equalTo: view.leadingAnchor, constant: 0),
            addToBasketButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: 0),
            addToBasketButton.heightAnchor.constraint   (equalToConstant: 60),
            
            
            collectionView.topAnchor.constraint         (equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint     (equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint    (equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint      (equalTo: addToBasketButton.topAnchor, constant: 0),
        ])
    }
    
    
    // MARK: - Animation
    
    private func animateButtonView(_ viewToAnimate: UIView) {
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


//MARK: - Extension
