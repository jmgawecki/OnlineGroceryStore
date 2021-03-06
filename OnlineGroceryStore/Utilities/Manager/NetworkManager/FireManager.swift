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



// MARK: - Enum


enum userPersistenceSubCollection: String {
    case usual          = "usual"
    case currentOrder   = "currentOrder"
    case favorites      = "favorites"
}


enum categoryOrProduct: String {
    case category       = "categoryImage/"
    case product        = "productImage/"
}


final class FireManager {
    // MARK: - Declaration
    
    
    static let shared   = FireManager()
    private init() {}
    
    let cache           = NSCache<NSString, UIImage>()
    let db              = Firestore.firestore()
    
    
    // MARK: - Firebase / Firestore
    
    /// Does not work for now. refactor somehow
//    func fetchCurrentUser(completed: @escaping(Result<UserLocal, Error>) -> Void) {
//        let userEmail = (Auth.auth().currentUser?.email)!
//        var user: UserLocal?
//
//        db.collection("usersData").document(userEmail).addSnapshotListener { (querySnapshot, error) in
//            guard let userDocument = querySnapshot else {
//                completed(.failure(error!))
//                return
//            }
//            do {
//                user = try? userDocument.data(as: UserLocal.self)
//                completed(.success(user!))
//            } catch {
//                completed(.failure(error))
//            }
//
//        }
//    }
    
    
    // MARK: - User
    
    
    func firebaseNetworkCheck() {
   
    }
    
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
    
    
    // MARK: - Product
    
    
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
    
    
    func fetchAllProducts(completed: @escaping(Result<[ProductLocal], Error>) -> Void) {
        var products: [ProductLocal] = []
        db.collection("products").addSnapshotListener { (querySnapshot, error) in
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
    

    func fetchProductsBasedOnTag(withTag: String, completed: @escaping(Result<[ProductLocal], Error>) -> Void) {
        var products: [ProductLocal] = []
        db.collection("products").whereField("tag", arrayContains: withTag).addSnapshotListener { (querySnapshot, error) in
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

    
    // MARK: - Category
    
    
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
    
    
    // MARK: - Basket
    
    
    func addOrderToBasket(for currentUser: UserLocal, order: Order, completed: @escaping(Error?) -> Void) {
        for product in order.products {
            var currentQuantity = 0
            db.collection("userPersistence")
                .document(currentUser.email)
                .collection("currentOrder")
                .document(product.id)
                .getDocument { [weak self] (documentSnapshot, error) in
                    guard let self = self else { return }
                    if let _ = error {
                        completed(error)
                        return
                    }
                    
                    if ((documentSnapshot?.exists) != nil) {
                        currentQuantity = documentSnapshot?["quantity"] as? Int ?? 0
                    }
                    self.db.collection("userPersistence")
                        .document(currentUser.email)
                        .collection("currentOrder")
                        .document(product.id)
                        .setData(["id":             product.id,
                                  "name":           product.name,
                                  "imageReference": product.imageReference,
                                  "price":          product.price,
                                  "discountMlt":    product.discountMlt,
                                  "quantity":       currentQuantity + product.quantity,
                                  "category":       product.category,
                                  "description":    product.description ?? "No product's description",
                                  "favorite":       product.favorite,
                                  "topOffer":       product.topOffer,
                                  "tag":            product.tag]) { error in
                            if let error = error {
                                completed(error)
                            } else {
                                completed(nil)
                            }
                        }
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
                        } else {
                            completed(nil)
                        }
                    }
            }
    }
    
    
    func updateProductBasketQuantity(for user: UserLocal, with product: ProductLocal, updatedQuantity quantity: Int, completed: @escaping(Error?) -> Void) {
        Firestore.firestore().collection("userPersistence")
            .document(user.email)
            .collection("currentOrder")
            .document(product.id)
            .getDocument { (documentSnapshot, error) in
                if let _ = error {
                    completed(error)
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
                              "quantity":       quantity,
                              "category":       product.category,
                              "description":    product.description ?? "No product's description",
                              "favorite":       product.favorite,
                              "topOffer":       product.topOffer,
                              "tag":            product.tag]) { error in
                        if let error = error {
                            completed(error)
                        } else {
                            completed(nil)
                        }
                    }
            }
    }
    
    
    func clearBasket(for user: UserLocal, from basket: [ProductLocal] ,completed: @escaping(Error?) -> Void) {
        for product in basket {
            db.collection("userPersistence").document(user.email).collection("currentOrder").document(product.id).delete { (error) in
                if let error = error {
                    completed(error)
                } else {
                    completed(nil)
                }
            }
            
        }
    }
    
    
    // MARK: - Image, Cache
    
    
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
    
    func clearCache() { cache.removeAllObjects() }
    
    
    // MARK: - Order
    
    
    func addOrder(for user: UserLocal, products: [ProductLocal], date: String, idOrder: String, completed: @escaping(Error?) -> Void) {
        var order: Order?
        order = Order(orderNumber: idOrder, date: date, products: products)
        do {
            let _ = try db.collection("userPersistence").document(user.email).collection("lastOrders").addDocument(from: order)
            completed(nil)
        } catch {
            completed(error)
        }
    }
    
    
    func fetchOrders(for user: UserLocal, completed: @escaping(Result<[Order], Error>) -> Void) {
        var orders: [Order] = []
        db.collection("userPersistence").document(user.email).collection("lastOrders").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                completed(.failure(error!))
                return
            }
            
            orders = documents.compactMap({ (queryDocumentSnapshot) -> Order? in
                return try? queryDocumentSnapshot.data(as: Order.self)
            })
            completed(.success(orders))
        }
    }
}
