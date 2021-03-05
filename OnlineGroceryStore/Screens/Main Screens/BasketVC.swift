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
    
    var basketTableView:    UITableView!
    var dataSource:         UITableViewDiffableDataSource<Section, ProductLocal>!
    var snapshot:           NSDiffableDataSourceSnapshot<Section, ProductLocal>!

    var orderButton = StoreImageLabelButton(fontSize: 20, message: "Proceed with Order", image: imageAsUIImage.foodPlaceholder!, textColor: UIColor(named: colorAsString.storeTertiary) ?? .green)
  
    var currentUser:        UserLocal!
    var basketProducts:     [ProductLocal] = []
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        layoutUI()
        configureVC()
        configureOrderButton()
    }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - @Objectives
    
    
    @objc private func orderButtonTapped(sender: UIView) {
        animateButtonView(sender)
        FireManager.shared.addOrder(for: currentUser, products: basketProducts, date: createTodaysDate(), idOrder: UUID().uuidString) { [weak self] (error) in
            guard let self = self else { return }
            switch error {
            case .none:
                self.basketProducts.removeAll()
                self.updateData()
            case .some(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - VC Configuration
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    
    private func configureOrderButton() {
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Firebase
    
    
    func fetchBasketProducts() {
        FireManager.shared.fetchProductsFromUserPersistenceSubCollection(for: currentUser, usualOrCurrentOrFavorites: .currentOrder) { [weak self] (result) in
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
    
    
    //MARK: - Layout UI
    
    
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
    
    
    // MARK: - Animation
    
    
    private func animateButtonView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
}


//MARK: - Extension

extension BasketVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = ProductDetailsVC(currentProduct: basketProducts[indexPath.row], currentUser: currentUser)
        navigationController?.present(destVC, animated: true)
    }
}
