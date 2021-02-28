//
//  NetworkManager.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 28/02/2021.
//

import UIKit
import Firebase
import FirebaseUI

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Firebase / Firestore
    
    func retrieveProductsFromFirestoreBasedOnField(collection: String, uponField: String, withCondition: Any, completed: @escaping(Result<[Product], Error>) -> Void) {
        var products: [Product] = []
        Firestore.firestore().collection(collection).whereField(uponField, isEqualTo: withCondition).getDocuments { (querySnapshot, error) in
            if let error = error {
                completed(.failure(error))
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    products.append(Product(name:             document.data()["name"]             as! String,
                                            description:      document.data()["description"]      as! String?,
                                            price:            document.data()["price"]            as! Double,
                                            favorite:         document.data()["favorite"]         as! Bool,
                                            category:         document.data()["category"]         as! String,
                                            imageReference:   document.data()["imageReference"]   as! String,
                                            id:               document.data()["id"]               as! String,
                                            discountMlt:      document.data()["discountMlt"]      as! Double,
                                            tag:              document.data()["tag"]              as! [String]))
                }
                completed(.success(products))
            }
        }
    }
    
    
    func retrieveDocumentsNameAsString(collection: String, completed: @escaping(Result<[String], Error>) -> Void) {
        var documents: [String] = []
        Firestore.firestore().collection(collection).getDocuments() { (querySnapshot, error) in
            if let error = error {
                completed(.failure(error))
            } else {
                for document in querySnapshot!.documents {
                    documents.append(document.documentID)
                }
                completed(.success(documents))
            }
        }
    }
    
}
