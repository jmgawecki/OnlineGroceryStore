//
//  BasketVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class BasketVC: UIViewController {
    // MARK: - Declaration
    
    
    enum Section { case main }
    
    var collectionView:         UICollectionView!
    var dataSource:             UICollectionViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:               NSDiffableDataSourceSnapshot<Section, ProductLocal>!
    
    var totalLabel              = StoreSecondaryTitleLabel(from: .right, alpha: 1)
    var orderButton             = StoreVCButton(fontSize: 20, label: "Place Order")
    
    var currentUser:            UserLocal!
    var basketProducts:         [ProductLocal] = []
    
    var bottomColorView  = UIView()
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBasketProducts()
        configureCollectionView()
        configureDataSource()
        configureUIElements()
        layoutUI()
        configureVC()
        
        configureOrderButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        StoreAnimation.animateTabBar(viewToAnimate: tabBarController!.tabBar, tabBarAnimationPath: .toOrder)
    }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func orderButtonTapped(sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        if basketProducts.isEmpty {
            presentStoreAlertOnMainThread(title: .failure, message: .basketIsEmpty, button: .willDo, image: .smilingBlackGirlR065)
            return
        }
        FireManager.shared.addOrder(for: currentUser, products: basketProducts, date: createTodaysDate(), idOrder: UUID().uuidString) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .none:
                self.clearTheBasket()
                self.updateDataOnCollection()
                self.collectionView.reloadData()
            case .some(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .concernedBlackGirlR056)
            }
        }
    }
    
    
    // MARK: - VC Configuration
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Collection View
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionLayouts.basketCollectionViewLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = StoreUIColor.creamWhite
        collectionView.delegate = self
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BasketCollectionViewCell, ProductLocal> { (cell, indexPath, product) in
            cell.set(with: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
    }
    
    
    private func updateDataOnCollection() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductLocal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(basketProducts, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    

    
    //MARK: - Private Function
    
    
    private func createTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    
    // MARK: - Button configuration
    
    
    private func configureOrderButton() { orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside) }
    
    
    // MARK: - Firebase
    
    
    func fetchBasketProducts() {
        FireManager.shared.fetchProductsFromUserPersistenceSubCollection(for: currentUser, usualOrCurrentOrFavorites: .currentOrder) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let basketProducts):
                self.basketProducts = basketProducts
                self.updateDataOnCollection()
                self.updateTotalLabel()
            case .failure(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .sadBlackGirlR056)
            }
        }
    }
    
    
    func clearTheBasket() {
        FireManager.shared.clearBasket(for: currentUser, from: basketProducts) { [weak self] (error) in
            guard let self = self else { return }
            if let _ = error {
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .ok, image: .sadBlackGirlR056)
            } else {
                self.basketProducts.removeAll()
                self.presentStoreAlertOnMainThread(title: .success, message: .orderPlaced, button: .ok, image: .happyBlackGirlR056)
            }
        }
    }

    
    #warning("implement uploading a basket and clearing the basket. cheks if the function exists in firemanager")
    
    // MARK: - UI Configuration
    
    
    private func configureUIElements() {
        orderButton.setTitleColor(StoreUIColor.mint, for: .normal)
        orderButton.backgroundColor         = StoreUIColor.black
        bottomColorView.backgroundColor     = StoreUIColor.grapefruit
        bottomColorView.layer.cornerRadius  = 44
        
        totalLabel.layer.cornerRadius       = 10
        totalLabel.textColor                = StoreUIColor.mint
        totalLabel.backgroundColor          = StoreUIColor.grapefruit
    }
    
    private func updateTotalLabel() {
        var total = 0.0
        for product in basketProducts {
            print(product)
            total += (product.price * product.discountMlt) * Double(product.quantity)
            print(total)
        }
        print(total)
        DispatchQueue.main.async {
            self.totalLabel.text = "Order Total: $\(String(format: "%.2f", total))"
        }
    }
    
    
    //MARK: - Layout UI
    
    
    private func layoutUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints    = false
        bottomColorView.translatesAutoresizingMaskIntoConstraints   = false
        addSubviews(bottomColorView, collectionView)
        bottomColorView.addSubviews(orderButton, totalLabel)
//        debugConfiguration(bottomColorView, collectionView, orderButton, totalLabel)
        
        NSLayoutConstraint.activate([
            orderButton.bottomAnchor.constraint         (equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3),
            orderButton.leadingAnchor.constraint        (equalTo: view.leadingAnchor, constant: 20),
            orderButton.trailingAnchor.constraint       (equalTo: view.trailingAnchor, constant: -20),
            orderButton.heightAnchor.constraint         (equalToConstant: 44),
            
            totalLabel.bottomAnchor.constraint          (equalTo: orderButton.topAnchor, constant: -10),
            totalLabel.trailingAnchor.constraint        (equalTo: orderButton.trailingAnchor, constant: 0),
            totalLabel.widthAnchor.constraint           (equalToConstant: 250),
            totalLabel.heightAnchor.constraint          (equalToConstant: 40),
    
            collectionView.topAnchor.constraint         (equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint     (equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint    (equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint      (equalTo: orderButton.topAnchor, constant: -50),

            bottomColorView.bottomAnchor.constraint     (equalTo: view.bottomAnchor, constant: 50),
            bottomColorView.leadingAnchor.constraint    (equalTo: view.leadingAnchor, constant: 0),
            bottomColorView.trailingAnchor.constraint   (equalTo: view.trailingAnchor, constant: 50),
            bottomColorView.topAnchor.constraint        (equalTo: collectionView.bottomAnchor, constant: 0),
        ])
    }
}


//MARK: - Extension

extension BasketVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC(currentProduct: basketProducts[indexPath.row], currentUser: currentUser)
        destVC.getProductImage(for: basketProducts[indexPath.item].id)
        navigationController?.present(destVC, animated: true)
    }
}

extension BasketVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = BasketProductDetailsVC(currentProduct: basketProducts[indexPath.item], currentUser: currentUser, basketProductDetailsVCDelegates: self)
        destVC.getProductImage(for: basketProducts[indexPath.item].id)
        navigationController?.present(destVC, animated: true)
    }
}

extension BasketVC: BasketProductDetailsVCDelegates {
    func updatedProductBasketQuantity() {
        self.presentStoreAlertOnMainThread(title: .success, message: .quantityUpdated, button: .ok, image: .happyBlackGirlR056)
    }
}
