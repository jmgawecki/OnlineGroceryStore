//
//  CategoriesVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit
import Firebase

class CategoriesVC: UIViewController {
    // MARK: - Declaration
    
    enum Section { case main }
    
    var categoriesTableView: UITableView!
    
    var categories: [String] = []
    
    var dataSource: UITableViewDiffableDataSource<Section, String>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, String>!
    
    
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        configureDataSource()
        getCategories()
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        title = "Categories"
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - UITableView Configuration
    
    
    private func configureTableView() {
        categoriesTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(categoriesTableView)
        categoriesTableView.rowHeight = 80
        categoriesTableView.delegate = self
        categoriesTableView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        categoriesTableView.register(BrowseByCategoryTableViewCell.self, forCellReuseIdentifier: BrowseByCategoryTableViewCell.reuseID)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: categoriesTableView, cellProvider: { (tableView, indexPath, category) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BrowseByCategoryTableViewCell.reuseID) as! BrowseByCategoryTableViewCell
            cell.currentCategory = category
            cell.set(with: category)
            cell.retrieveImageWithPathReferenceFromDocument(from: category)
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
        NetworkManager.shared.retrieveDocumentsNameAsString(collection: "groceryCategory") { [weak self] (result) in
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

extension CategoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = ProductsVC()
        destVC.currentCategory = categories[indexPath.row]
        #warning("how to add category's title?")
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
