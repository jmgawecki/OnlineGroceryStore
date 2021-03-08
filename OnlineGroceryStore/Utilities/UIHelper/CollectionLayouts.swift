//
//  CollectionViewLayouts.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

struct CollectionLayouts {
    
    
    static func favoriteCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize        = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        
        let item            = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets  = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize       = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .estimated(250))
        
        let group           = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])
        
        let section         = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
    
    static func productsVCCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize        = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        
        let item            = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets  = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize       = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(240))
        
        let group           = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])
        
        let section         = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
    
    static func searchVCCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize        = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        
        let item            = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets  = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5)
        
        let groupSize       = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(240))
        
        let group           = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])
        
        let section         = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
    
    static func odersVCCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize        = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        
        let item            = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets  = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize       = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(350))
        
        let group           = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])
        
        let section         = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
    
    static func basketCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize        = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        
        let item            = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets  = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize       = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(100))
        
        let group           = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])
        
        let section         = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
}
