//
//  SalesViewController.swift
//  temp-uikit-layout
//
//  Created by Effie on 2023/06/14.
//

import UIKit

class SalesViewController: UIViewController {
    private let collectionView = ProductListCollectionView()
    private lazy var dataSource: ProductListDataSource = ProductListDataSource(collectionView)
    
    private let segementedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["판매중", "판매완료"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var segementedControlContainer: UIView = {
        let container = UIView(frame: .zero)
        container.addSubview(segementedControl)
        NSLayoutConstraint.activate([
            segementedControl.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            segementedControl.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            segementedControl.widthAnchor.constraint(equalToConstant: 240),
        ])
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            segementedControlContainer,
            BorderLine(height: 1),
            collectionView,
        ])
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "판매 내역"
        setLayout()
        applyUpdatedSnapshot()
    }
    
    private func setLayout() {
        view.addSubview(segementedControlContainer)
        NSLayoutConstraint.activate([
            segementedControlContainer.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func applyUpdatedSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, ProductListItem>()
        snapshot.appendSections([.product, .load])
        // TODO: 임시 코드 수정
        let products = Products().products.map { ProductListItem.product($0) }
        snapshot.appendItems(products, toSection: .product)
        if true { snapshot.appendItems([.load], toSection: .load) }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
