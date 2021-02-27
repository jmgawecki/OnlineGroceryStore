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
    
    var collectionView: UICollectionView!
    var dataSource:     UICollectionViewDiffableDataSource<Section, Product>!
    
    var products: [Product] = []
    var currentCategory: String!
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        configureCollectionView()
        configureDataSource()
        retrieveProductsFromFirestoreBasedOnField()
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
    
    
    private func retrieveProductsFromFirestoreBasedOnField() {
        Firestore.firestore().collection("products").whereField("category", isEqualTo: currentCategory.lowercased()).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.products.append(Product(name: document.data()["name"] as! String,
                                                 description: document.data()["description"] as! String?,
                                                 price: document.data()["price"] as! Double,
                                                 favorite: document.data()["favorite"] as! Bool,
                                                 category: document.data()["category"] as! String,
                                                 imageReference: document.data()["imageReference"] as! String,
                                                 id: document.data()["id"] as! String))
                }
                self.updateDataOnCollection()
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
        let cellRegistration = UICollectionView.CellRegistration<ProductsVCCollectionViewCell, Product> { (cell, indexPath, product) in
            cell.set(with: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> ProductsVCCollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    private func updateDataOnCollection() {
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
