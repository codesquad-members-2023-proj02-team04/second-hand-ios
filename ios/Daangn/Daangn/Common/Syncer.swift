//
//  Syncer.swift
//  Daangn
//
//  Created by Effie on 2023/06/30.
//

import Foundation

protocol ListSyncer {
    associatedtype EntityDTO
    associatedtype Entity
    
    static func syncAppend(to list: Entity, newDTO: EntityDTO)
}

enum ProductListSyncer: ListSyncer {
    typealias EntityDTO = ProductListOnPage
    typealias Entity = Products
    
    static func syncAppend(to list: Products, newDTO: ProductListOnPage) {
        guard let newItems = newDTO.products else {
            list.endPagination()
            return
        }
        list.add(newItems)
        if newDTO.hasNext == false { list.endPagination() }
    }
}
