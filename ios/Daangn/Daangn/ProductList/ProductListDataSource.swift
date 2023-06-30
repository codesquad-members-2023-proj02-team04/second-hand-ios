//
//  ProductListDataSource.swift
//  temp-uikit-layout
//
//  Created by Effie on 2023/06/14.
//

import UIKit

enum ProductListSection {
    case product
    case load
}

enum ProductListItem: Hashable {
    // TODO: Int > Product 타입으로 교체
    case product(Product)
    case load
}

final class ProductListDataSource: UICollectionViewDiffableDataSource<ProductListSection, ProductListItem> {
    typealias ProductCell = ProductListCollectionViewCell
    typealias LoadCell = LoadCollectionViewCell
    
    static let cellProvider: CellProvider = { collectionView, indexPath, itemIdentifier in
        switch itemIdentifier {
        case .product(let product):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(ProductCell.self)",
                for: indexPath
            ) as? ProductCell else { return UICollectionViewCell() }
            cell.configure(with: product)
            return cell
        case .load:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(LoadCell.self)",
                for: indexPath
            ) as? LoadCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    typealias CollectionView = ProductListCollectionView
    
    convenience init(_ collectionView: CollectionView) {
        self.init(collectionView: collectionView, cellProvider: Self.cellProvider)
    }
}
