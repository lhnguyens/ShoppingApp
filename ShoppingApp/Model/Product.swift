//
//  Product.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import Foundation

struct Product: Decodable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
    let category: Category
    
    
    struct Category: Decodable, Equatable {
        let id: Int
        let name: String
    }
}
