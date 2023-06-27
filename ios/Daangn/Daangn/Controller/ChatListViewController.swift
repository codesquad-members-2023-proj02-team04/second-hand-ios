//
//  ChatListViewController.swift
//  Daangn
//
//  Created by Effie on 2023/06/27.
//

import UIKit

class ChatListViewController: UIViewController {
    private let border = BorderLine(height: 1)
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewLayoutGenerator.createListLayout()
    )
    private lazy var dataSource: ChatListDataSource = ChatListDataSource(collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채팅"
        setCollectionView()
        setLayout()
    }
    
    private func setCollectionView() {
        let layout = CollectionViewLayoutGenerator.createListLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func setLayout() {
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            border.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: border.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
