//
//  CategoryType.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import Foundation

enum CategoryType: String, CaseIterable {
    case clothes = "Clothes"
    case electronics = "Electronics"
    case furniture = "Furniture"
    case shoes = "Shoes"
    case misc = "Misc"
    
    static func from(name: String) -> CategoryType {
        CategoryType(rawValue: name) ?? .misc
    }
    
    var displayName: String {
        self.rawValue
    }
}
