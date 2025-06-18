//
//  ShoppingListViewModel.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import Foundation
import UIKit

@MainActor
class ShoppingListViewModel {
    
    private(set) var productImages: [ProductImage] = []
    private var products: [Product] = []
    
    private let loader: ProductLoading
    
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(loader: ProductLoading) {
        self.loader = loader
    }
}

// MARK: - Api calls

extension ShoppingListViewModel {
    
    func fetchData() {
        Task {
            do {
                let allProducts = try await loader.fetchProducts()
                
                let filteredProducts = allProducts.filter {
                    loader.firstImageURL(product: $0) != nil
                }
                
                self.products = filteredProducts
                
                try await withThrowingTaskGroup(of: ProductImage.self) { group in
                    for product in products {
                        guard let url = loader.firstImageURL(product: product) else { continue }
                        group.addTask {
                            let image = try await self.loader.fetchImage(url: url)
                            return ProductImage(id: product.id, image: image)
                        }
                    }
                    
                    for try await image in group {
                        self.productImages.append(image)
                    }
                }
                
                onUpdate?()
            } catch {
                onError?(error)
            }
        }
    }
}

// MARK: - Sections

extension ShoppingListViewModel {
    
    var sections: [Section] {
        CategoryType.allCases.compactMap { category in
            let matchingProducts = products.filter {
                CategoryType.from(name: $0.category.name) == category
            }
            return matchingProducts.isEmpty ? nil : Section(category: category,
                                                            products: matchingProducts)
        }
    }
}
