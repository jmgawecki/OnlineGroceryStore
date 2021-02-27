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
    var categoriesTableView: UITableView!
    
    var categories: [String] = []
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        configureUITableView()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - @Objectives
    
    
    
    
    //MARK: - Private Function
    
    
    private func configureVC() {
        title = "Search By Category"
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
    }
    
    private func configureUITableView() {
        categoriesTableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(categoriesTableView)
        categoriesTableView.rowHeight = 80
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.backgroundColor = UIColor(named: colorAsString.storeBackground)
        categoriesTableView.register(BrowseByCategoryTableViewCell.self, forCellReuseIdentifier: BrowseByCategoryTableViewCell.reuseID)
    }
    
    
    //MARK: - Layout configuration
    
    
    private func layoutUI() {
        
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
                self.categoriesTableView.reloadData()
            }
        }
    }
}


//MARK: - Extension

extension CategoriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BrowseByCategoryTableViewCell.reuseID) as! BrowseByCategoryTableViewCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = ProductsVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
}


