//
//  BasketVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import PassKit

final class BasketVC: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    var dataSource: UITableViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:   NSDiffableDataSourceSnapshot<Section, ProductLocal>!

    var basketTableView: UITableView!
    var currentUser: UserLocal!
    
    var basketProducts: [ProductLocal] = []
    
    var orderButton = StoreImageLabelButton(fontSize: 20, message: "Proceed with Order", image: imageAsUIImage.foodPlaceholder!, textColor: UIColor(named: colorAsString.storeTertiary) ?? .green)
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        layoutUI()
        getCurrentUser()
        configureVC()
        configureUIElements()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentUser()
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Firebase
    
    
    func getCurrentUser() {
        NetworkManager.shared.getCurrentUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                self.currentUser = currentUser
                self.getBasketProducts()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getBasketProducts() {
        NetworkManager.shared.retrieveProductsFromUserPersistenceSubCollection(for: currentUser, for: .currentOrder) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let basketProducts):
                self.basketProducts = basketProducts
                self.updateData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: - UITableView Configuration


    private func configureTableView() {
        basketTableView = UITableView(frame: CGRect.zero, style: .plain)
        basketTableView.rowHeight = 80
        basketTableView.delegate = self
        basketTableView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        basketTableView.register(BasketVCTableViewCell.self, forCellReuseIdentifier: BasketVCTableViewCell.reuseID)
    }


    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ProductLocal>(tableView: basketTableView, cellProvider: { (tableView, indexPath, product) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BasketVCTableViewCell.reuseID) as! BasketVCTableViewCell
            cell.set(with: product)
            return cell
        })
    }


    private func updateData() {
        snapshot = NSDiffableDataSourceSnapshot<Section, ProductLocal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(basketProducts, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
    }
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        basketTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(orderButton, basketTableView)
        debugConfiguration(orderButton, basketTableView)
        
        NSLayoutConstraint.activate([
            orderButton.bottomAnchor.constraint         (equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            orderButton.leadingAnchor.constraint        (equalTo: view.leadingAnchor, constant: 0),
            orderButton.trailingAnchor.constraint       (equalTo: view.trailingAnchor, constant: 0),
            orderButton.heightAnchor.constraint         (equalToConstant: 60),

            basketTableView.topAnchor.constraint        (equalTo: view.topAnchor, constant: 0),
            basketTableView.leadingAnchor.constraint    (equalTo: view.leadingAnchor, constant: 0),
            basketTableView.trailingAnchor.constraint   (equalTo: view.trailingAnchor, constant: 0),
            basketTableView.bottomAnchor.constraint     (equalTo: orderButton.topAnchor, constant: 0),
        ])
    }
    
}


//MARK: - Extension

extension BasketVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("do a check for current user")
        let destVC = ProductDetailsVC()
        #warning("how to add category's title?")
        
        navigationController?.present(destVC, animated: true)
    }
}
