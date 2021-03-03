//
//  CategoryProductsVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import Firebase
import FirebaseUI

final class ProductsVC: UIViewController {
    // MARK: - Declaration
    enum Section { case main }
    
    var collectionView:     UICollectionView!
    var dataSource:         UICollectionViewDiffableDataSource<Section, ProductLocal>!
    
    var products:           [ProductLocal] = []
    var currentUser:        UserLocal!
    var currentCategory:    String!
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        configureCollectionView()
        configureDataSource()
        getProducts()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("tralala")
    }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
    }
    
    
    // MARK: - Firebase
    
    
    private func getProducts() {
        FireManager.shared.fetchProductsBasedOnField(collection: "products", uponField: "category", withCondition: currentCategory.lowercased()) { [weak self] (result) in
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
    
    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionLayouts.productsVCCollectionViewLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: colorAsString.storeBackground)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductsVCCollectionViewCell, ProductLocal> { (cell, indexPath, product) in
            cell.set(with: product, currentUser: self.currentUser)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> ProductsVCCollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    private func updateDataOnCollection() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductLocal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true); self.collectionView.reloadData() }
        
    }
    
    
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        
    }
    
    
}


//MARK: - Extension

extension ProductsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC()
        #warning("do a check if current user exists")
        destVC.currentUser = currentUser!
        navigationController?.present(destVC, animated: true)
    }
}
