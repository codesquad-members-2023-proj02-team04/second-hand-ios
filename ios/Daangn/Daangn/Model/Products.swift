//
//  Products.swift
//  Daangn
//
//  Created by Effie on 2023/06/30.
//

import Foundation
import OrderedCollections

class Products {
    private static let defaultPageOffset = 20
    
    enum Notifications {
        static let ProductAdded = Notification.Name(rawValue: "ProductAdded")
    }
    
    private(set) var products: OrderedSet<Product> = []
    private(set) var page: Int = 0
    private(set) var hasNextPage: Bool = true
    
    private func updatePage() {
        page += 1
    }
    
    func add(_ products: [Product]) {
        if products.count < Self.defaultPageOffset { endPagination() }
        
        for product in products {
            self.products.updateOrAppend(product)
        }
        updatePage()
        NotificationCenter.default.post(name: Notifications.ProductAdded, object: nil)
    }
    
    func endPagination() {
        self.hasNextPage = false
    }
}
