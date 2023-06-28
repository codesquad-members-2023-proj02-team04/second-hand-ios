//
//  ProductStateBadge.swift
//  temp-uikit-layout
//
//  Created by Effie on 2023/06/14.
//

import UIKit

final class ProductStateBadge: RoundedPaddedLabel {
    private static let edgeInset = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
    
    override init(radius: CGFloat, inset: UIEdgeInsets) {
        super.init(radius: radius, inset: Self.edgeInset)
        setProperties()
    }
    
    private func setProperties() {
        applyStyle(font: FontStyle.caption1, color: ColorStyle.white)
    }
    
    func configure(state: ProductState) {
        self.text = state.korean
        self.backgroundColor = state.color
    }
}
