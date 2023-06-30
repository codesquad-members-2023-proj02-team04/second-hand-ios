//
//  ProductList.swift
//  Daangn
//
//  Created by Effie on 2023/06/20.
//

import Foundation

struct ProductListOnPage: Decodable {
    let products: [Product]?
    let hasNext: Bool
}

struct Product: Decodable, Hashable {
    let productId: Int
    let title: String
    let price: Int?
    let createdAt: String
    let status: String
    let location: Location
    let watchlistCounts: Int
    let chatroomCounts: Int
    let mainImage: ProductImage?
    let watchlist: Bool
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.productId == rhs.productId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(productId)
    }
}

struct Location: Decodable, Hashable {
    let locationId: Int
    let district: String
    let city: String
    let town: String
}

struct ProductImage: Decodable, Hashable {
    let productImageId: Int
    let imageUrl: String
}

struct TempSignUpPostLocation: Codable, Hashable {
    let locationId: Int
    
    init() {
        self.locationId = 1
    }
}
