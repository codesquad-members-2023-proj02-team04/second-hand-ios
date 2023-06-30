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
    
    let list = Products()
    
    private let town = "역삼1동"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setLayout()
        collectionView.delegate = self
        addObserver()
        
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
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateList),
            name: Products.Notifications.ProductAdded,
            object: nil
        )
    }
}

extension HomeViewController {
    @objc func moveToCategory() {
        let nextViewController = CategoryViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func updateList() {
        self.applyUpdatedSnapshot()
    }
}

extension HomeViewController {
    private func getProducts() {
        Task { [weak self] in
            do {
                guard let self else { return }
                let list = try await self.manager.getProducts(page: self.list.page)
                ProductListSyncer.syncAppend(to: self.list, newDTO: list)
            } catch {
                print(error)
            }
        }
    }
    
    private func applyUpdatedSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, ProductListItem>()
        snapshot.appendSections([.product])
        let products = list.products.map { ProductListItem.product($0) }
        snapshot.appendItems(products, toSection: .product)
        if list.hasNextPage {
            snapshot.appendSections([.load])
            snapshot.appendItems([.load], toSection: .load)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(
       _ collectionView: UICollectionView,
       willDisplay cell: UICollectionViewCell,
       forItemAt indexPath: IndexPath
    ) {
        if indexPath == IndexPath(item: 0, section: 1) && list.hasNextPage {
          getProducts()
       }
    }
}
