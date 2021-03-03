//
//  NetworkManager.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 28/02/2021.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseFirestoreSwift


enum userPersistenceSubCollection: String {
    case usual          = "usual"
    case currentOrder   = "currentOrder"
    case favorites      = "favorites"
}


enum categoryOrProduct: String {
    case category       = "categoryImage/"
    case product        = "productImage/"
}


class NetworkManager {
    
    static let shared   = NetworkManager()
    let cache           = NSCache<NSString, UIImage>()
    let db = Firestore.firestore()
    private init() {}
    
    // MARK: - Firebase / Firestore
    
    
    func getCurrentUserData(completed: @escaping(Result<UserLocal, Error>) -> Void) {
        let userEmail = (Auth.auth().currentUser?.email)!
        Firestore.firestore().collection("usersData").document(userEmail).getDocument(completion: { (user, error) in
            if let error = error {
                completed(.failure(error))
                return
            } else {
                let currentUser = UserLocal(uid:       user?.data()!["uid"]            as! String,
                                            firstName: user?.data()!["firstname"]      as! String,
                                            lastName:  user?.data()!["lastname"]       as! String,
                                            email:     userEmail)
                completed(.success(currentUser))
                #warning("How to make it better? How to append name to a label before class is initialised. Tried in scene delegate but its a one big mess")
            }
        })
    }
    
    func fetchProductsBasedOnField(collection: String, uponField: String, withCondition: Any, completed: @escaping(Result<[ProductLocal], Error>) -> Void) {
        var products: [ProductLocal] = []
        
        db.collection(collection).whereField(uponField, isEqualTo: withCondition).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                completed(.failure(error!))
                return
            }
            
            products = documents.compactMap({ (queryDocumentSnapshot) -> ProductLocal? in
                return try? queryDocumentSnapshot.data(as: ProductLocal.self)
            })
            completed(.success(products))
        }
    }

    
    func fetchProductsFromUserPersistenceSubCollection(for user: UserLocal, usualOrCurrentOrFavorites: userPersistenceSubCollection, completed: @escaping(Result<[ProductLocal], Error>) -> Void) {
        var products: [ProductLocal] = []
        db.collection("userPersistence").document(user.email).collection(usualOrCurrentOrFavorites.rawValue).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                completed(.failure(error!))
                return
            }
            
            products = documents.compactMap({ (queryDocumentSnapshot) -> ProductLocal? in
                return try? queryDocumentSnapshot.data(as: ProductLocal.self)
            })
            completed(.success(products))
        }
    }
    


    
    func retrieveProductsFromFirestoreBasedOnTag(withTag: String, completed: @escaping(Result<[ProductLocal], Error>) -> Void) {
        var products: [ProductLocal] = []
        Firestore.firestore().collection("products").whereField("tag", arrayContains: withTag).getDocuments { (querySnapshot, error) in
            if let error = error {
                completed(.failure(error))
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    products.append(ProductLocal(name:             document.data()["name"]             as! String,
                                                 description:      document.data()["description"]      as! String?,
                                                 price:            document.data()["price"]            as! Double,
                                                 favorite:         document.data()["favorite"]         as! Bool,
                                                 category:         document.data()["category"]         as! String,
                                                 imageReference:   document.data()["imageReference"]   as! String,
                                                 id:               document.data()["id"]               as! String,
                                                 discountMlt:      document.data()["discountMlt"]      as! Double,
                                                 tag:              document.data()["tag"]              as! [String],
                                                 topOffer:         document.data()["topOffer"]         as! Bool,
                                                 quantity:         document.data()["quantity"]         as! Int))
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
    
    
    func addProductToBasket(for user: UserLocal, with product: ProductLocal, howMany quantity: Int, completed: @escaping(Error?) -> Void) {
        var currentQuantity = 0
        Firestore.firestore().collection("userPersistence")
            .document(user.email)
            .collection("currentOrder")
            .document(product.id)
            .getDocument { (documentSnapshot, error) in
                if let _ = error { // debug check
                    print("no product")
                }
                if ((documentSnapshot?.exists) != nil) {
                    currentQuantity = documentSnapshot?["quantity"] as? Int ?? 0
                }
                Firestore.firestore().collection("userPersistence")
                    .document(user.email)
                    .collection("currentOrder")
                    .document(product.id)
                    .setData(["id":             product.id,
                              "name":           product.name,
                              "imageReference": product.imageReference,
                              "price":          product.price,
                              "discountMlt":    product.discountMlt,
                              "quantity":       quantity + currentQuantity,
                              "category":       product.category,
                              "description":    product.description ?? "No product's description",
                              "favorite":       product.favorite,
                              "topOffer":       product.topOffer,
                              "tag":            product.tag]) { error in
                        if let error = error {
                            completed(error)
                        }
                    }
            }
    }
    
    
    func retrieveImageWithPathReferenceFromDocument(from category: String, categoryOrProduct: categoryOrProduct ,completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: category)
        if let image = cache.object(forKey: cacheKey) { completed(image) }
        
        switch categoryOrProduct {
        case .category:
            Firestore.firestore().collection("groceryCategory").document(category).getDocument { (category, error) in
                let pathReference = Storage.storage().reference(withPath: "categoryImage/\(category?.data()!["imageReference"] as! String)")
                
                pathReference.getData(maxSize: 1 * 2024 * 2024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.cache.setObject(UIImage(data: data!)!, forKey: cacheKey)
                        completed(UIImage(data: data!)!)
                    }
                }
            }
            
        case .product:
            Firestore.firestore().collection("products").document(category).getDocument { (category, error) in
                let pathReference = Storage.storage().reference(withPath: "productImage/\(category?.data()!["imageReference"] as! String)")
                
                pathReference.getData(maxSize: 1 * 2024 * 2024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.cache.setObject(UIImage(data: data!)!, forKey: cacheKey)
                        completed(UIImage(data: data!)!)
                    }
                }
            }
        }
    }
    

    func confirmOrder2(for user: UserLocal, products: [ProductLocal], date: String, idOrder: String) {
        
        for product in products {
            Firestore.firestore().collection("userPersistence")
                .document(user.email)
                .collection("lastOrders")
                .document(date)
                .collection(idOrder)
                .addDocument(data: ["id":             product.id,
                                    "name":           product.name,
                                    "imageReference": product.imageReference,
                                    "price":          product.price,
                                    "discountMlt":    product.discountMlt,
                                    "quantity":       product.quantity,
                                    "category":       product.category,
                                    "description":    product.description ?? "No product's description",
                                    "favorite":       product.favorite,
                                    "topOffer":       product.topOffer,
                                    "tag":            product.tag]) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    func confirmOrder(for user: UserLocal, products: [ProductLocal], date: String, idOrder: String) {
        
        for product in products {
            Firestore.firestore().collection("userPersistence")
                .document(user.email)
                .collection("lastOrders")
                .document(date)
                .collection(idOrder)
                .document(product.id)
                .setData(["id":             product.id,
                          "name":           product.name,
                          "imageReference": product.imageReference,
                          "price":          product.price,
                          "discountMlt":    product.discountMlt,
                          "quantity":       product.quantity,
                          "category":       product.category,
                          "description":    product.description ?? "No product's description",
                          "favorite":       product.favorite,
                          "topOffer":       product.topOffer,
                          "tag":            product.tag]) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    func confirmOrder3(for user: UserLocal, products: [ProductLocal], date: String, idOrder: String) {
        
        Firestore.firestore().collection("userPersistence")
            .document(user.email)
            .collection("lastOrders")
            .document(idOrder)
            .setData(["orderNumber":    idOrder,
                      "date":           date,
                      "products":       ["product1": products[0]]]) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
    }
    
    func getLastOrders(for user: UserLocal) {
        Firestore.firestore().collection("userPersistence")
                            .document(user.email)
                            .collection("lastOrders")
                            .getDocuments { (snapshot, error) in
                                print(user.email)
                                print(error)
                                print("Tralalalal")
                                print(snapshot?.documents)
                                for document in snapshot!.documents {
                                    print("tralalala")
                                    print(document.documentID)
                                }
                            }
        Firestore.firestore().document("/userPersistence/jmgawecki@icloud.com/lastOrders").getDocument {  (snapshot, error) in
            print(user.email)
            print(error)
            print("Tralalalal")
            print(snapshot)
            
        }
        
    }
}
