//
//  SpecialOffersView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

class SpecialOffersView: UIView {
    // MARK: - Declaration
    
    enum Section { case main }
    
    let hiNameLabel             = StoreBoldLabel(with: "Special Offers",
                                                 from: .left,
                                                 ofsize: 20,
                                                 ofweight: .bold,
                                                 alpha: 1,
                                                 color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    var collectionView: UICollectionView!
    var dataSource:     UICollectionViewDiffableDataSource<Section, Product>!
    var snapshot:       NSDiffableDataSourceSnapshot<Section, Product>!
    
    var products: [Product] = MockData.products
    
    var segmentedControl: UISegmentedControl!
    
    
    let items                   = ["Top Offers", "Half price", "Only $1"]
    // MARK: - Override and Initialise
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        layoutUI()
        configureDataSource()
        configureSnapshot()
        configureSegmentedControl()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//
//    init(<#parameters#>) {
//        <#statements#>
//    }
//
    // MARK: - View Configuration
    
    
    
    // MARK: - Collection View Configuration
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionLayouts.favoriteCollectionViewLayout())
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
    
    
    
    // MARK: - UI Configuration
    
    private func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = UIColor(named: colorAsString.storeTertiary)
    }
    
    
    
    
    // MARK: - Layout UI
    
    
    private func layoutUI() {
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(hiNameLabel, segmentedControl, collectionView)
//        debugConfiguration(hiNameLabel, segmentedControl, collectionView)
        
        
        NSLayoutConstraint.activate([
            hiNameLabel.topAnchor.constraint            (equalTo: topAnchor, constant: 0),
            hiNameLabel.leadingAnchor.constraint        (equalTo: leadingAnchor, constant: 15),
            hiNameLabel.trailingAnchor.constraint       (equalTo: trailingAnchor, constant: 0),
            hiNameLabel.heightAnchor.constraint         (equalToConstant: 30),
            
            segmentedControl.topAnchor.constraint       (equalTo: hiNameLabel.bottomAnchor, constant: 5),
            segmentedControl.leadingAnchor.constraint   (equalTo: leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint  (equalTo: trailingAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint    (equalToConstant: 30),
            
            collectionView.topAnchor.constraint         (equalTo: segmentedControl.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint     (equalTo: leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint    (equalTo: trailingAnchor, constant: 0),
            collectionView.heightAnchor.constraint      (equalToConstant: 200),
        ])
    }
}
