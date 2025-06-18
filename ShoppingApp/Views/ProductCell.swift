//
//  ProductCell.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import UIKit

class ProductCell: UITableViewCell {
    
    func configure(product: Product, image: UIImage?) {
        textLabel?.text = product.title
        if let image {
            imageView?.image = image
            imageView?.contentMode = .scaleAspectFit
        }
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
}
