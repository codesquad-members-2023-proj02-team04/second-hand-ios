//
//  ChatListDataSource.swift
//  Daangn
//
//  Created by Effie on 2023/06/27.
//

import UIKit

enum ChatListSection {
    case chat
    case load
}

enum ChatListItem: Hashable {
    // TODO: Int > Chat 타입으로 교체
    case chat(Int)
    case load
}

final class ChatListDataSource: UICollectionViewDiffableDataSource<ChatListSection, ChatListItem> {
    typealias ChatCell = ChatListCollectionViewCell
    typealias LoadCell = LoadCollectionViewCell
    
    static let cellProvider: CellProvider = { collectionView, indexPath, itemIdentifier in
        switch itemIdentifier {
        case .chat:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(ChatCell.self)",
                for: indexPath
            ) as? ChatCell else { return UICollectionViewCell() }
            cell.configure()
            return cell
        case .load:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(LoadCell.self)",
                for: indexPath
            ) as? LoadCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    convenience init(_ collectionView: UICollectionView) {
        self.init(collectionView: collectionView, cellProvider: Self.cellProvider)
    }
}
