//
//  SearchVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

class SearchVC: UIViewController {
    // MARK: - Declaration
    
//    var collectionView: UICollectionView!
//    var dataSource:     UICollectionViewDiffableDataSource<Section, Product>!
//    var snapshot:       NSDiffableDataSourceSnapshot<Section, Product>!
//
    var isSearching         = false


    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        configureSearchController()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Collection View
    
   
//    
//    var products: [Product] = []
//    
//    private func configureCollectionView() {
//        collectionView = UICollectionView()
//        view.addSubview(collectionView)
//        collectionView.collectionViewLayout = UICollectionViewLayout() // your custom here
//        // tamic delete or leave depending if collectionView is view.bounds. If its with manual constrain then
//        // collectionView.frame = CGRect.zero
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    private func configureDataSource() {
//        let cellRegistration = UICollectionView.CellRegistration<FavoritesCollectionViewCell, Product> { (cell, indexPath, identifier) in
//            cell.set()
//        }
//
//        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> UICollectionViewCell? in
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
//        })
//    }
//
//    private func configureSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(products, toSection: .main)
//
//        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
//    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
       
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        
    }
    
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
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
//        filteredFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased())}
//        updateData(on: filteredFollowers)
        isSearching = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
//        updateData(on: followers)
    }
}
