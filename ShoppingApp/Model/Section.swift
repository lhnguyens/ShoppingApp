//
//  Section.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import Foundation

struct Section {
    let category: CategoryType
    let products: [Product]
    
    var title: String {
        category.displayName
    }
}
