//
//  Products.swift
//  Daangn
//
//  Created by Effie on 2023/06/30.
//

import Foundation
import OrderedCollections

class Products {
    enum Notifications {
        static let ProductAdded = Notification.Name(rawValue: "ProductAdded")
    }
    
    private(set) var products: OrderedSet<Product> = []
    private(set) var hasNextPage: Bool = true
    
    func add(_ products: [Product]) {
        for product in products {
            self.products.updateOrAppend(product)
        }
        NotificationCenter.default.post(name: Notifications.ProductAdded, object: nil)
    }
    
    func endPagination() {
        self.hasNextPage = false
    }
}
