//
//  ChatListViewController.swift
//  Daangn
//
//  Created by Effie on 2023/06/27.
//

import UIKit

class ChatListViewController: UIViewController {
    typealias ChatCell = ChatListCollectionViewCell
    typealias LoadCell = LoadCollectionViewCell
    
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
        applyUpdatedSnapshot()
    }
    
    private func setCollectionView() {
        let layout = CollectionViewLayoutGenerator.createListLayout()
        collectionView.collectionViewLayout = layout
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: "\(ChatCell.self)")
        collectionView.register(LoadCell.self, forCellWithReuseIdentifier: "\(LoadCell.self)")
    }
    
    private func setLayout() {
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    private func applyUpdatedSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ChatListSection, ChatListItem>()
        snapshot.appendSections([.chat, .load])
        // TODO: 임시 코드 수정
        let chats = (1...100).map { ChatListItem.chat($0) }
        snapshot.appendItems(chats, toSection: .chat)
        if true { snapshot.appendItems([.load], toSection: .load) }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
