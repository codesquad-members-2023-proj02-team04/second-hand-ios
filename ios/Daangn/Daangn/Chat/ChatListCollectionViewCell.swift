//
//  ChatListCollectionViewCell.swift
//  Daangn
//
//  Created by Effie on 2023/06/27.
//

import UIKit

class ChatListCollectionViewCell: UICollectionViewCell {
    static let cellIntrinsicHeight: CGFloat = 48
    
    // MARK: Views
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        let radius = ChatListCollectionViewCell.cellIntrinsicHeight / 2
        imageView.setRadius(constant: radius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: FontStyle.subhead, color: ColorStyle.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: FontStyle.footnote, color: ColorStyle.gray800)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userNameContainer: UIView = {
        let view = UIView()
        view.addSubview(userNameLabel)
        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 4),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recentMessageLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: FontStyle.footnote, color: ColorStyle.gray900)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameLabel, recentMessageLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private let unreadCountLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: FontStyle.footnote, color: ColorStyle.gray900)
        label.backgroundColor = ColorStyle.orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLableStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [unreadCountLabel, UIView()])
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        return stack
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        let radius: CGFloat = 8
        imageView.setRadius(constant: radius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = ColorStyle.gray600?.cgColor
        return imageView
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userProfileImageView, labelStack, countLableStack, productImageView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return stack
    }()
    
    // MARK: Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setMargin()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMargin()
        setLayout()
    }
    
    // MARK: Instance Methods
    
    private func setMargin() {
        contentView.directionalLayoutMargins = .init(top: 15, leading: 16, bottom: 15, trailing: 16)
        contentView.preservesSuperviewLayoutMargins = false
    }
    
    private func setLayout() {
        self.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configure() {
        
    }
}
