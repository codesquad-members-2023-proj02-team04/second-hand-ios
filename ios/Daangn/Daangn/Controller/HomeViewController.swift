//
//  HomeViewController.swift
//  Daangn
//
//  Created by ilim on 2023/06/13.
//

import UIKit

final class HomeViewController: UIViewController {
    private let collectionView = ProductListCollectionView()
    private lazy var dataSource: ProductListDataSource = ProductListDataSource(collectionView)
    
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setLayout()
        applyUpdatedSnapshot()
        
        getProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func applyUpdatedSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, ProductListItem>()
        snapshot.appendSections([.product, .load])
        // TODO: 임시 코드 수정
        let products = (1...100).map { ProductListItem.product($0) }
        snapshot.appendItems(products, toSection: .product)
        if true { snapshot.appendItems([.load], toSection: .load) }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private let town = "역삼1동"
    
    private func menuHandler(action: UIAction) {
        Swift.debugPrint("Menu handler: \(action.title)")
    }
    
    private func moveToTownPicker(action: UIAction) {
        present(ConfigureTown(), animated: true)
    }
    
    private func setNavigationBar() {
        let leftButton = UIBarButtonItem(title: town, style: .plain, target: self, action: nil)
        let rightButtonImage = UIImage(systemName: "line.3.horizontal")
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(moveToCategory))
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString(town, comment: ""), handler: menuHandler),
            UIAction(title: NSLocalizedString("내 동네 설정하기", comment: ""), handler: moveToTownPicker)
        ])
        leftButton.menu = barButtonMenu
        configureNavBarButtonColor(left: leftButton, right: rightButton)
    }
    
    private func configureNavBarButtonColor(left: UIBarButtonItem, right: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = right
        navigationItem.leftBarButtonItem = left
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func moveToCategory() {
        let nextViewController = CategoryViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func getProducts() {
        Task {
            do {
                let list = try await manager.getProducts(page: 0)
                guard let products = list.products else { throw NetworkError.noData }
            } catch {
                print(error)
            }
        }
    }
}
