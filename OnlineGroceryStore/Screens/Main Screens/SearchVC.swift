//
//  SearchVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class SearchVC: UIViewController {
    // MARK: - Declaration
    
    
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var dataSource:     UICollectionViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:       NSDiffableDataSourceSnapshot<Section, ProductLocal>!
    
    var products:       [ProductLocal] = []
    var currentUser:    UserLocal!
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureDataSource()
        configureSearchController()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) { FireManager.shared.clearCache() }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    // MARK: - Firebase
    
    
    private func fetchSearchedProducts(collection: String, uponField: String, withCondition: String) {
        FireManager.shared.fetchProductsBasedOnTag(withTag: withCondition) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                print(products)
                self.products.removeAll()
                self.products.append(contentsOf: products)
                self.updateDataOnCollection()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
  
    
    //MARK: - VC Configuration
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Collection View
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionLayouts.searchVCCollectionViewLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        collectionView.delegate = self
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductsVCCollectionViewCell, ProductLocal> { (cell, indexPath, product) in
            cell.set(with: product, currentUser: self.currentUser )
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
    

    //MARK: - Layout configuration
    
    
    private func configureSearchController() {
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Type a username"
        navigationItem.searchController         = searchController
        searchController.obscuresBackgroundDuringPresentation = false
    }
}


//MARK: - Extension

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyTag = searchController.searchBar.text, !keyTag.isEmpty else { return }
        fetchSearchedProducts(collection: "products", uponField: "id", withCondition: keyTag.lowercased())
        collectionView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        updateData(on: followers)
    }
}

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC(currentProduct: products[indexPath.item], currentUser: currentUser)
        destVC.getProductImage(for: products[indexPath.item].id)
        navigationController?.present(destVC, animated: true)
    }
}
