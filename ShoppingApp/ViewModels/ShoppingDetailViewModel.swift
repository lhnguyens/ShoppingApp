//
//  ShoppingDetailViewModel.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import Foundation
import UIKit

struct ShoppingDetailViewModel {
    let title: String
    let description: String
    let priceText: String
    let image: UIImage?
    
    init(product: Product, image: UIImage?) {
        self.title = product.title
        self.description = product.description
        self.priceText = "\(product.price) SEK"
        self.image = image
    }
}
