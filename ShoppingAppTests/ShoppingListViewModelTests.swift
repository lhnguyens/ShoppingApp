//
//  ShoppingAppTests.swift
//  ShoppingAppTests
//
//  Created by Caroline Neuman on 2025-06-18.
//

import XCTest
@testable import ShoppingApp

class ShoppingListViewModelTests: XCTestCase {
        
        func test_fetchData_SectionsAndImages() async throws {
            
            let mockLoader = MockLoader()
            mockLoader.products = [
                Product(
                    id: 1,
                    title: "T-shirt",
                    price: 149,
                    description: "Good quality and made in italy",
                    images: ["https://mock.com/1.jpg"],
                    category: .init(id: 10, name: "Clothes")
                ),
                Product(
                    id: 2,
                    title: "Sneakers",
                    price: 799,
                    description: "Shoes to run quick",
                    images: ["https://mock.com/2.jpg"],
                    category: .init(id: 20, name: "Shoes")
                )
            ]
            mockLoader.imageMap = [
                1: UIImage(systemName: "tshirt")!,
                2: UIImage(systemName: "shoeprints.fill")!
            ]
            
            let viewModel = await ShoppingListViewModel(loader: mockLoader)
            let expectation = expectation(description: "onUpdate called")
            
            await MainActor.run {
                viewModel.onUpdate = {
                    expectation.fulfill()
                }
            }
            
            await MainActor.run {
                viewModel.fetchData()
            }
            
            await fulfillment(of: [expectation], timeout: 2)
            
            await MainActor.run {
                XCTAssertEqual(viewModel.sections.count, 2)
                XCTAssertEqual(viewModel.sections[0].products.count, 1)
                XCTAssertEqual(viewModel.sections[1].products[0].title, "Sneakers")
            }
            
            let image = await ProductImage.image(id: 1, models: viewModel.productImages)
            XCTAssertNotNil(image)
        }
    
    func test_Fetch_Error() async {
        let mockLoader = MockLoader()
        mockLoader.shouldFail = true
        
        let viewModel = await ShoppingListViewModel(loader: mockLoader)
        let expectation = expectation(description: "onError called")
        
        await MainActor.run {
            viewModel.onError = { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        await viewModel.fetchData()
        await fulfillment(of: [expectation], timeout: 2)
    }
}

class MockLoader: ProductLoading {
    var products: [Product] = []
    var imageMap: [Int: UIImage] = [:]
    var shouldFail = false
    
    func fetchProducts() async throws -> [Product] {
        if shouldFail {
            throw ProductError.invalidResponse
        }
        return products
    }
    
    func fetchImage(url: URL?) async throws -> UIImage {
        guard let url = url,
              let idString = url.lastPathComponent.split(separator: ".").first,
              let id = Int(idString),
              let image = imageMap[id] else {
            return UIImage()
        }
        return image
    }
    
    func firstImageURL(product: Product) -> URL? {
        guard let first = product.images.first else { return nil }
        return URL(string: first)
    }
    
}
