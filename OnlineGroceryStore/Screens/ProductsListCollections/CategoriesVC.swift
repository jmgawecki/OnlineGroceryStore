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
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        title = "Search By Category"
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - UITableView Configuration
    
    
    private func configureTableView() {
        categoriesTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(categoriesTableView)
        categoriesTableView.rowHeight = 80
        categoriesTableView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        categoriesTableView.register(BrowseByCategoryTableViewCell.self, forCellReuseIdentifier: BrowseByCategoryTableViewCell.reuseID)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: categoriesTableView, cellProvider: { (tableView, indexPath, category) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BrowseByCategoryTableViewCell.reuseID) as! BrowseByCategoryTableViewCell
            cell.currentCategory = category
            cell.retrieveImageWithUrlFromDocument(from: category)
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

    
    func retrieveDocumentsNameAsString() {
        Firestore.firestore().collection("groceryCategory").getDocuments() { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.categories.append(document.documentID)
                }
                self.updateData()
            }
        }
    }
    
    func retrieveImageWithUrlFromDocument() {
        for category in categories {
            Firestore.firestore().collection("groceryCategory").document(category).getDocument { (category, error) in
                print("nothing")
            }
        }
    }
}
