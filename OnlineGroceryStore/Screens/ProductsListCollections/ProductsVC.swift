//
//  CategoryProductsVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class ProductsVC: UIViewController {
    // MARK: - Declaration
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var dataSource:     UICollectionViewDiffableDataSource<Section, Product>!
    
    var products: [Product] = MockData.products
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        configureCollectionView()
        configureDataSource()
        configureSnapshot()
        // Do any additional setup after loading the view.
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
    
    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionLayouts.productsVCCollectionViewLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: colorAsString.storeBackground)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FavoritesCollectionViewCell, Product> { (cell, indexPath, identifier) in
            cell.set()
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        
    }
    
    
}


//MARK: - Extension

extension ProductsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC()
        navigationController?.present(destVC, animated: true)
    }
}
