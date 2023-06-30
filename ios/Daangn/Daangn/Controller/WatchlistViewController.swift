//
//  WatchlistViewController.swift
//  Daangn
//
//  Created by ilim on 2023/06/13.
//

import UIKit

final class WatchlistViewController: UIViewController {
    typealias FilterCell = CategoryFilterCollectionViewCell
    
    private let filterCollectionView = CategoryFilterCollectionView()
    private lazy var filterDataSource: CateogryFilterDataSource = CateogryFilterDataSource(filterCollectionView)
    private let productCollectionView = ProductListCollectionView()
    private lazy var productListDataSource: ProductListDataSource? = ProductListDataSource(productCollectionView)
    
    private lazy var collectionViewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            BorderLine(height: 1),
            filterCollectionView,
            productCollectionView
        ])
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "관심 목록"
        setLayout()
        setFilter()
        applyUpdatedSnapshot()
    }
    
    private func setLayout() {
        view.addSubview(filterCollectionView)
        NSLayoutConstraint.activate([
            filterCollectionView.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        view.addSubview(collectionViewStack)
        NSLayoutConstraint.activate([
            collectionViewStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionViewStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionViewStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionViewStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setFilter() {
        var snapshot = NSDiffableDataSourceSnapshot<FilterSection, Category>()
        snapshot.appendSections([.category])
        snapshot.appendItems(Category.allCases, toSection: .category)
        filterDataSource.apply(snapshot, animatingDifferences: true)
        
        filterCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func applyUpdatedSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, ProductListItem>()
        snapshot.appendSections([.product, .load])
        // TODO: 임시 코드 수정
        let products = Products().products.map { ProductListItem.product($0) }
        snapshot.appendItems(products, toSection: .product)
        if true { snapshot.appendItems([.load], toSection: .load) }
        productListDataSource?.apply(snapshot, animatingDifferences: true)
    }
}
