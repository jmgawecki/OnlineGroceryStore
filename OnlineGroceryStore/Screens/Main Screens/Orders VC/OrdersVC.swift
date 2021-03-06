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
    
    var categoriesTableView:    UITableView!
    var dataSource:             UITableViewDiffableDataSource<Section, Order>!
    var snapshot:               NSDiffableDataSourceSnapshot<Section, Order>!
 
    var orders:         [Order] = []
    var currentUser:    UserLocal!
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) { fetchOrders() }
    
    
    override func viewWillDisappear(_ animated: Bool) { FireManager.shared.clearCache() }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    
    
    
    //MARK: - VC Configuration
    
    
    private func configureVC() {
        view.backgroundColor = colorAsUIColor.storeBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Firebase

    
    func fetchOrders() {
        FireManager.shared.fetchOrders(for: currentUser) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.orders = orders
                self.updateDataOnCollection()
                
            case .failure(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .sadBlackGirlR056)
            }
        }
    }
    
    
    // MARK: - Table View Configuration
    
    
    private func configureTableView() {
        categoriesTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(categoriesTableView)
        categoriesTableView.rowHeight = 80
        categoriesTableView.delegate = self
        categoriesTableView.backgroundColor = colorAsUIColor.storeBackground
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
}


// MARK: - Extension


extension OrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = LastOrderVC(with: orders[indexPath.item], for: currentUser)
        destVC.currentUser = currentUser
        destVC.lastOrderVCDelegates = self
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension OrdersVC: LastOrderVCDelegates {
    func didRequestDismissal() {
        self.presentStoreAlertOnMainThread(title: .success, message: .orderAddedToBasket, button: .ok, image: .happyBlackGirlR056)
    }
}
