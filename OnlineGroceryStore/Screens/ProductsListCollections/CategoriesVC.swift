//
//  CategoriesVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import Firebase

final class CategoriesVC: UIViewController {
//    var coordinator: Coordinator?
    
    // MARK: - Declaration
    
    enum Section { case main }
    
    var categoriesTableView: UITableView!
    
    var categories:     [String] = []
    var currentUser:    UserLocal!
    
    var dataSource:     UITableViewDiffableDataSource<Section, String>!
    var snapshot:       NSDiffableDataSourceSnapshot<Section, String>!
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureDataSource()
        getCategories()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        FireManager.shared.clearCache()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        StoreAnimation.animateTabBar(viewToAnimate: tabBarController!.tabBar, tabBarAnimationPath: .fromOrder)
    }
    
    
    init(currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = currentUser
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        title = "Categories"
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - UITableView Configuration
    
    
    private func configureTableView() {
        categoriesTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(categoriesTableView)
        categoriesTableView.rowHeight = 80
        categoriesTableView.delegate = self
        categoriesTableView.backgroundColor = StoreUIColor.creamWhite
        categoriesTableView.register(BrowseByCategoryTableViewCell.self, forCellReuseIdentifier: BrowseByCategoryTableViewCell.reuseID)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: categoriesTableView, cellProvider: { (tableView, indexPath, category) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BrowseByCategoryTableViewCell.reuseID) as! BrowseByCategoryTableViewCell
            cell.currentCategory = category
            cell.set(with: category)
            return cell
        })
        
        
    }
    
    
    private func updateData() {
        snapshot = NSDiffableDataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(categories, toSection: .main)
        DispatchQueue.main.async { self.dataSource.apply(self.snapshot, animatingDifferences: true) }
    }

    
    //MARK: - Firebase
    
    func getCategories() {
        FireManager.shared.retrieveDocumentsNameAsString(collection: "groceryCategory") { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                self.updateData()
            case .failure(let error):
                print(error)
            }
        }
    }
}


    // MARK: - Extension


extension CategoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC              = ProductsVC(currentUser: currentUser!)
        destVC.currentCategory  = categories[indexPath.row]
        destVC.title            = categories[indexPath.row]
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
