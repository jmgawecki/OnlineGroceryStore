//
//  SpecialOffersView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

    // MARK: - Protocol & Delegate

protocol SpecialOffersViewDelegate: class {
    func presentProductDetailModally()
}

final class SpecialOffersView: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    let hiNameLabel             = StoreBoldLabel(with: "Special Offers",
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
    
    weak var specialOffersViewDelegate: SpecialOffersViewDelegate!
    
    let items                   = ["Top Offers", "Half price", "Only $1"]
    // MARK: - Override and Initialise
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSegmentedControl()
        configureSegmentedControlSwitch()
        layoutUI()
        configureDataSource()
        updateDataOnCollection()
    }

//
//    init(<#parameters#>) {
//        <#statements#>
//    }
//
    
    // MARK: - @Objectives
    
    @objc private func segmentedControlSwitched() {
        if segmentedControl.selectedSegmentIndex == 0 {
            getProducts(uponField: "topOffer", withCondition: true)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            getProducts(uponField: "discountMlt", withCondition: Double(0.5))
        } else if segmentedControl.selectedSegmentIndex == 2 {
            getProducts(uponField: "price", withCondition: Double(1))
        }
    }
    
    
    // MARK: - Private functions
    
    
    private func configureSegmentedControlSwitch() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlSwitched), for: .valueChanged)
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
//    
//    private func getProducts(uponField: String, withCondition: Any) {
//        NetworkManager.shared.retrieveProductsFromFirestoreBasedOnField(collection: "products", uponField: uponField, withCondition: withCondition) { [weak self] (result) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let products):
//                self.products.removeAll()
//                self.products.append(contentsOf: products)
//                self.configureSnapshot()
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
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
        let items        = ["Top offers", "Half price", "Only $1"]
        segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex       = 0
        segmentedControl.selectedSegmentTintColor   = UIColor(named: colorAsString.storeTertiary)
        
        getProducts(uponField: "topOffer", withCondition: true)
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


extension SpecialOffersView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC()
        present(destVC, animated: true)
    }
}
