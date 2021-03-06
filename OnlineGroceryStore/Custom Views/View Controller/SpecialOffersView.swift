//
//  SpecialOffersView.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

    // MARK: - Protocol & Delegate

protocol SpecialOffersViewDelegate: class {
    func productDetailsRequestedDismissal()
}


final class SpecialOffersView: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    var collectionView:         UICollectionView!
    var dataSource:             UICollectionViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:               NSDiffableDataSourceSnapshot<Section, ProductLocal>!
    
    let hiNameLabel             = StoreTitleLabel(from: .left, alpha: 1)

    var segmentedControl:       UISegmentedControl!
    
    var products:               [ProductLocal] = []
    var currentUser:            UserLocal!
    
    let items                   = ["Top Offers", "Half price", "Only $1"]
    
    weak var specialOffersViewDelegate: SpecialOffersViewDelegate!
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSegmentedControl()
        configureSegmentedControlSwitch()
        layoutUI()
        configureUIElements()
        configureDataSource()
        updateDataOnCollection()
    }
    
    
    init(currentUser: UserLocal, specialOffersViewDelegate: SpecialOffersViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
        self.specialOffersViewDelegate = specialOffersViewDelegate
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
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
    
    
    private func configureSegmentedControlSwitch() { segmentedControl.addTarget(self, action: #selector(segmentedControlSwitched), for: .valueChanged) }
    
    private func configureUIElements() {
        hiNameLabel.text = "Special Offers"
    }
    
    
    private func configureSegmentedControl() {
        let items        = ["Top offers", "Half price", "Only $1"]
        segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex       = 0
        segmentedControl.selectedSegmentTintColor   = colorAsUIColor.storeTertiary
        
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
        let destVC = ProductDetailsVC(currentProduct: products[indexPath.item], currentUser: currentUser)
        destVC.getProductImage(for: products[indexPath.item].id)
        destVC.productDetailVCDelegateForHomeVC = self
        present(destVC, animated: true)
    }
}


extension SpecialOffersView: ProductDetailVCDelegateForHomeVC {
    func dismissProductDetailVC() {
        print("Tralalalala")
        specialOffersViewDelegate.productDetailsRequestedDismissal()
    }
}

