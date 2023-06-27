//
//  ProductListCollectionViewCell.swift
//  temp-uikit-layout
//
//  Created by Effie on 2023/06/12.
//

import UIKit

final class ProductListCollectionViewCell: UICollectionViewCell {
    // MARK: Views
    
    private let productImage: ProductListImageView = ProductListImageView(frame: .zero)
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.applyStyle(font: FontStyle.subhead, color: ColorStyle.gray900)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = ColorStyle.gray800
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 17).isActive = true
        
        button.addTarget(nil, action: #selector(tapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, button])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return stack
    }()
    
    private let locationLabel: UILabel = ProductListCollectionViewCell.footnoteLabelMaker(nil)
    
    private let dotLabel: UILabel = ProductListCollectionViewCell.footnoteLabelMaker("・")
    
    private let timeStampLabel: UILabel = ProductListCollectionViewCell.footnoteLabelMaker(nil)
    
    private let stateBadge: ProductStateBadge = ProductStateBadge(radius: .roundedRectangle, inset: .init())
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.applyStyle(font: FontStyle.headline, color: ColorStyle.gray900)
        label.textColor = ColorStyle.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var informationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleButtonStack, locationTimeStack, statePriceStack])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var locationTimeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationLabel, dotLabel, timeStampLabel, UIView()])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return stack
    }()
    
    private lazy var statePriceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stateBadge, priceLabel, UIView()])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let chatIcon: UIImageView = iconImageViewMaker("message")
    
    private let chatCountLabel: UILabel = ProductListCollectionViewCell.footnoteLabelMaker(nil)
    
    private let heartIcon: UIImageView = iconImageViewMaker("heart")
    
    private let heartCountLabel: UILabel = ProductListCollectionViewCell.footnoteLabelMaker(nil)
    
    private lazy var chatStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [chatIcon, chatCountLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var heartStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heartIcon, heartCountLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var chatHeartStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [chatStack, heartStack])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.addSubview(productImage)
        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            productImage.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 120),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
        ])
        let imageBottomConstraint = productImage.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        imageBottomConstraint.priority = .defaultHigh
        imageBottomConstraint.isActive = true
        
        contentView.addSubview(informationStack)
        NSLayoutConstraint.activate([
            informationStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            informationStack.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 15),
            informationStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 4),
        ])
        
        contentView.addSubview(chatHeartStack)
        NSLayoutConstraint.activate([
            chatHeartStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            chatHeartStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4),
            chatHeartStack.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc func tapped() {
#if DEBUG
        print("tap")
#endif
    }
}

extension ProductListCollectionViewCell {
    // MARK: Cell Configure
    
    func configure() {
        //        productImage.image = UIImage(named: "")
        titleLabel.text = "글 제목"
        locationLabel.text = "역삼동"
        timeStampLabel.text = "2시간 전"
        stateBadge.configure(state: .reserved)
        priceLabel.text = "24,500원"
        
        chatCountLabel.text = "0"
        heartCountLabel.text = "0"
    }
}

extension ProductListCollectionViewCell {
    // MARK: Static Properties
    
    private static let footnoteLabelMaker: (String?) -> UILabel = { text in
        let label = UILabel(frame: .zero)
        label.text = text
        label.applyStyle(font: FontStyle.footnote, color: ColorStyle.gray900)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private static let iconImageViewMaker: (String) -> UIImageView = { symbolName in
        let imageView = UIImageView(image: UIImage(systemName: symbolName))
        imageView.tintColor = ColorStyle.gray900
        imageView.preferredSymbolConfiguration = .init(scale: .small)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
}
