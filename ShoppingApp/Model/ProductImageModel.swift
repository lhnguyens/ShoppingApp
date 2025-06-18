//
//  ProductImageModel.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import UIKit

struct ProductImage: Equatable {
    let id: Int
    let image: UIImage
    
    static func image(id: Int, models: [ProductImage]) -> UIImage? {
        models.first(where: { $0.id == id })?.image
    }
}
