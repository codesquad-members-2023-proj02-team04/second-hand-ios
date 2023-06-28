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
            userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            userNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
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
        let stack = UIStackView(arrangedSubviews: [userNameContainer, recentMessageLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let unreadCountLabel: UILabel = {
        let label = PaddedLabel(inset: .init(top: 3, left: 6, bottom: 3, right: 6))
        label.applyStyle(font: FontStyle.footnote, color: ColorStyle.white)
        label.backgroundColor = ColorStyle.orange
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
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = ColorStyle.gray600?.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userProfileImageView, labelStack, countLableStack, productImageView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    // MARK: Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setMargin()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setMargin()
        setLayout()
    }
    
    // MARK: Instance Methods
    
    private func setUI() {
        self.backgroundColor = .white
    }
    
    private func setMargin() {
        contentView.directionalLayoutMargins = .init(top: 15, leading: 16, bottom: 15, trailing: 16)
        contentView.preservesSuperviewLayoutMargins = false
    }
    
    private func setLayout() {
        contentView.addSubview(userProfileImageView)
        NSLayoutConstraint.activate([
            userProfileImageView.heightAnchor.constraint(equalToConstant: Self.cellIntrinsicHeight),
            userProfileImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            userProfileImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            userProfileImageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])

//        contentView.addSubview(userNameContainer)
//        NSLayoutConstraint.activate([
//            userNameContainer.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//            userNameContainer.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8),
//        ])
//
//        contentView.addSubview(recentMessageLabel)
//        NSLayoutConstraint.activate([
//            recentMessageLabel.leadingAnchor.constraint(equalTo: userNameContainer.leadingAnchor),
//            recentMessageLabel.topAnchor.constraint(equalTo: userNameContainer.bottomAnchor, constant: 6),
//            recentMessageLabel.widthAnchor.constraint(equalTo: userNameContainer.widthAnchor),
//        ])

        contentView.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8),
            labelStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
        ])

//        contentView.addSubview(countLableStack)
//        NSLayoutConstraint.activate([
//            countLableStack.leadingAnchor.constraint(equalTo: labelStack.trailingAnchor, constant: 8),
//            countLableStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//            countLableStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
//            countLableStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 8),
//        ])
        
        contentView.addSubview(unreadCountLabel)
        NSLayoutConstraint.activate([
//            unreadCountLabel.leadingAnchor.constraint(equalTo: userNameContainer.trailingAnchor, constant: 8),
            unreadCountLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
        ])
        
        contentView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: unreadCountLabel.trailingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
        
        let midConstraint = userNameContainer.trailingAnchor.constraint(equalTo: unreadCountLabel.leadingAnchor, constant: -8)
        midConstraint.priority = .init(1000)
        midConstraint.isActive = true
//
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(stack)
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
//            stack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
//            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
//            stack.heightAnchor.constraint(equalToConstant: Self.cellIntrinsicHeight),
//        ])
    }
    
    func configure() {
        userProfileImageView.image = UIImage(named: "daangn")
        userNameLabel.text = "삼만보"
        timeLabel.text = "4분전"
        recentMessageLabel.text = "안녕하세요! 궁금한 점이 있어서 챗 드립니다. 혹시 언제 구매하셨나요? 이염은 없나요?! 오늘 저녁에 거래 가능한가요~"
        unreadCountLabel.text = "\(8)"
        productImageView.image = UIImage(named: "daangn")
    }
}
