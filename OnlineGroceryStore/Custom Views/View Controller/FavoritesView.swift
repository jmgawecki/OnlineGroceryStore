//
//  StoreSegmentedControl3.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class FavoritesView: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    let hiNameLabel             = StoreBoldLabel(with: "Favorites",
                                                 from: .left,
                                                 ofsize: 20,
                                                 ofweight: .bold,
                                                 alpha: 1,
                                                 color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    var collectionView: UICollectionView!
    var dataSource:     UICollectionViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:       NSDiffableDataSourceSnapshot<Section, ProductLocal>!
    
    var products: [ProductLocal] = []
    var currentUser: UserLocal!
    var segmentedControl: UISegmentedControl!
    
    
    // MARK: - Override and Initialise
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        configureCollectionView()
        configureSegmentedControl()
        layoutUI()
        configureDataSource()
        updateDataOnCollection()
        
        configureSegmentedControlSwitch()
    }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

    // MARK: - @Objectives
    
    @objc private func segmentedControlSwitched() {
        if segmentedControl.selectedSegmentIndex == 0 {
//            getProducts(uponField: <#T##String#>, withCondition: <#T##Any#>)
        } else if segmentedControl.selectedSegmentIndex == 1 {
//            getLastOrders()
        } else if segmentedControl.selectedSegmentIndex == 2 {
            print("third")
        }
    }
    
    
    // MARK: - Firebase / Firestore
    
    
    private func getProducts(uponField: String, withCondition: Any) {
        FireManager.shared.fetchProductsBasedOnField(collection: "products", uponField: uponField, withCondition: withCondition) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
                self.updateDataOnCollection()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getLastOrders() {
        guard let currentUser = currentUser else {
            getCurrentUser()
            print("no current user try again!")
            return
        }
        FireManager.shared.fetchOrders(for: currentUser) { (result) in
            switch result {
            case .success(let orders):
                self.products.removeAll()
                for order in orders {
                    for product in order.products {
                        if self.products.contains(product) { } else {
                            self.products.append(contentsOf: order.products)
                        }
                    }
                }
                self.updateDataOnCollection()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getCurrentUser() {
        FireManager.shared.getCurrentUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                self.currentUser = currentUser
                self.getLastOrders()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Private functions
    
    
    private func configureSegmentedControlSwitch() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlSwitched), for: .valueChanged)
    }
    
    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionLayouts.favoriteCollectionViewLayout())
        collectionView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FavoritesCollectionViewCell, ProductLocal> { (cell, indexPath, product) in
            cell.set(with: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    private func updateDataOnCollection() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductLocal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products, toSection: .main)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    
    // MARK: - UI Configuration
    
    private func configureSegmentedControl() {
        let items        = ["Favorite", "Last orders", "Usual"]
        segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex       = 0
        segmentedControl.selectedSegmentTintColor   = UIColor(named: colorAsString.storeTertiary)
    }
    
    
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(hiNameLabel, segmentedControl, collectionView)
//        debugConfiguration(hiNameLabel, segmentedControl, collectionView)
        
        
        NSLayoutConstraint.activate([
            hiNameLabel.topAnchor.constraint            (equalTo: view.topAnchor, constant: 0),
            hiNameLabel.leadingAnchor.constraint        (equalTo: view.leadingAnchor, constant: 15),
            hiNameLabel.trailingAnchor.constraint       (equalTo: view.trailingAnchor, constant: 0),
            hiNameLabel.heightAnchor.constraint         (equalToConstant: 30),
            
            segmentedControl.topAnchor.constraint       (equalTo: hiNameLabel.bottomAnchor, constant: 5),
            segmentedControl.leadingAnchor.constraint   (equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint  (equalTo: view.trailingAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint    (equalToConstant: 30),
            
            collectionView.topAnchor.constraint         (equalTo: segmentedControl.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint     (equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint    (equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint      (equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}

    // MARK: - Extension

extension FavoritesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navigationController = UINavigationController()
        let destVC = ProductDetailsVC(currentProduct: products[indexPath.item], currentUser: currentUser)
        navigationController.present(destVC, animated: true)
    }
}