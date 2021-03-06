//
//  StoreSegmentedControl3.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

protocol LastsVCDelegates: class {
    func productDetailsRequestedDismissalThroughLasts()
}

final class LastsVC: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    var collectionView:         UICollectionView!
    var dataSource:             UICollectionViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:               NSDiffableDataSourceSnapshot<Section, ProductLocal>!
    
    let hiNameLabel             = StoreTitleLabel(from: .left, alpha: 1)
   
    var products:               [ProductLocal] = []
    var currentUser:            UserLocal!

    var lastsVCDelegates: LastsVCDelegates!
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        layoutUI()
        configureUIElements()
        configureDataSource()
        updateDataOnCollection()
    }
    
    
    override func viewWillAppear(_ animated: Bool) { getLastOrdersID() }
    
    
    init(currentUser: UserLocal, lastsVCDelegates: LastsVCDelegates) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
        self.lastsVCDelegates = lastsVCDelegates
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
   

    // MARK: - @Objectives
    
    
    
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

    
    private func getLastOrdersID() {
        var idsArray: [String] = []
        FireManager.shared.fetchOrders(for: currentUser) { (result) in
            switch result {
            case .success(let orders):
                var tempProducts: [ProductLocal] = []
                for order in orders {
                    for product in order.products {
                        tempProducts.append(product)
                    }
                }
                var set1: Set<String> = []
                
                for product in tempProducts { set1.insert(product.id) }
                idsArray = Array(set1)
                
                self.getLastOrdersProducts(with: idsArray)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func getLastOrdersProducts(with ids: [String]) {
        var lastOrdersProducts: [ProductLocal] = []
        FireManager.shared.fetchAllProducts { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                for id in ids {
                    let foundProduct = products.filter { $0.id == id}
                    lastOrdersProducts.append(foundProduct[0])
                }
                self.products = lastOrdersProducts
                self.updateDataOnCollection()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionLayouts.favoriteCollectionViewLayout())
        collectionView.backgroundColor = colorAsUIColor.storeBackground
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
    
    
    private func configureUIElements() {
        hiNameLabel.text = "Favorites"
    }
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(hiNameLabel, collectionView)
//        debugConfiguration(hiNameLabel, segmentedControl, collectionView)
        
        
        NSLayoutConstraint.activate([
            hiNameLabel.topAnchor.constraint            (equalTo: view.topAnchor, constant: 0),
            hiNameLabel.leadingAnchor.constraint        (equalTo: view.leadingAnchor, constant: 15),
            hiNameLabel.trailingAnchor.constraint       (equalTo: view.trailingAnchor, constant: 0),
            hiNameLabel.heightAnchor.constraint         (equalToConstant: 30),
            
            collectionView.topAnchor.constraint         (equalTo: hiNameLabel.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint     (equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint    (equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint      (equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}


    // MARK: - Extension


extension LastsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC(currentProduct: products[indexPath.item], currentUser: currentUser)
        destVC.getProductImage(for: products[indexPath.item].id)
        destVC.productDetailVCDelegateForHomeVC = self
        present(destVC, animated: true)
    }
}

extension LastsVC: ProductDetailVCDelegateForHomeVC {
    func dismissProductDetailVC() {
        lastsVCDelegates.productDetailsRequestedDismissalThroughLasts()
    }
}
