//
//  OrdersVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class OrdersVC: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
 
    var orders: [Order] = []
    var currentUser: UserLocal!
    
    
    var categoriesTableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, Order>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Order>!
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        configureVC()
        configureUIElements()
        layoutUI()
        configureTableView()
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireManager.shared.clearCache()
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
        FireManager.shared.getCurrentUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                self.currentUser = currentUser
                self.fetchOrders()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func fetchOrders() {
        FireManager.shared.fetchOrders(for: currentUser) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.orders = orders
                self.updateDataOnCollection()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Table View Configuration
    
    
    private func configureTableView() {
        categoriesTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(categoriesTableView)
        categoriesTableView.rowHeight = 80
        categoriesTableView.delegate = self
        categoriesTableView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        categoriesTableView.register(OrdersVCTableViewCell.self, forCellReuseIdentifier: OrdersVCTableViewCell.reuseID)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Order>(tableView: categoriesTableView, cellProvider: { (tableView, indexPath, order) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersVCTableViewCell.reuseID) as! OrdersVCTableViewCell
            cell.set(with: order)
            return cell
        })
    }
    
    
    private func updateDataOnCollection() {
        snapshot = NSDiffableDataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(orders, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
    }

    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
       
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        
    }
    
    
}


// MARK: - Extension


extension OrdersVC: UITableViewDelegate {
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    #warning("do a check for current user")
    let destVC = LastOrderVC(with: orders[indexPath.item])
    destVC.currentUser = currentUser
    
    navigationController?.pushViewController(destVC, animated: true)
}
}
