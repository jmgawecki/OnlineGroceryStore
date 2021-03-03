//
//  StoreSegmentedControl3.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class FavoritesView: UIView {
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
    
    var segmentedControl: UISegmentedControl!
    
    
    // MARK: - Override and Initialise
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureSegmentedControl()
        layoutUI()
        configureDataSource()
        updateDataOnCollection()
        
        configureSegmentedControlSwitch()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - @Objectives
    
    @objc private func segmentedControlSwitched() {
        if segmentedControl.selectedSegmentIndex == 0 {
//            getProducts(uponField: <#T##String#>, withCondition: <#T##Any#>)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            print("second")
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
            collectionView.bottomAnchor.constraint      (equalTo: bottomAnchor, constant: 0),
        ])
    }
}

    // MARK: - Extension

extension FavoritesView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navigationController = UINavigationController()
        let destVC = ProductDetailsVC()
        navigationController.present(destVC, animated: true)
    }
}
