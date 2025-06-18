//
//  ProductLoader.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import Foundation
import UIKit

protocol ProductLoading {
    func fetchProducts() async throws -> [Product]
    func fetchImage(url: URL?) async throws -> UIImage
    func firstImageURL(product: Product) -> URL?
}

enum ProductError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .statusCode(let code): return "Invalid status code: \(code)"
        case .decodingError(let error): return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        }
    }
}

class ProductLoader: ProductLoading {
    
    private let urlString = "https://api.escuelajs.co/api/v1/products"
    
    func fetchProducts() async throws -> [Product] {
        do {
            guard let url = URL(string: urlString) else {
                throw ProductError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                throw ProductError.invalidResponse
            }
            
            guard (200...299).contains(response.statusCode) else {
                throw ProductError.statusCode(response.statusCode)
            }
            
            do {
                let result = try JSONDecoder().decode([Product].self, from: data)
                return result
            } catch {
                throw ProductError.decodingError(error)
            }
        } catch {
            throw ProductError.networkError(error)
        }
    }
    
    func fetchImage(url: URL?) async throws -> UIImage {
        do {
            guard let url = url else {
                throw ProductError.invalidURL
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw ProductError.decodingError(NSError(domain: "Image decoding", code: -1))
            }
            return image
        } catch {
            throw ProductError.networkError(error)
        }
    }
    
    // Some of the images were dead so filter out those to only look for jpeg, jpg and png.
    func firstImageURL(product: Product) -> URL? {
        let validExtensions = ["jpg", "jpeg", "png"]
        return product.images
            .compactMap { URL(string: $0) }
            .first(where: { validExtensions.contains($0.pathExtension.lowercased()) })
    }
}
