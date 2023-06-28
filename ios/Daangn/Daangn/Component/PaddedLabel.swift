//
//  PillShapeLabel.swift
//  temp-uikit-layout
//
//  Created by Effie on 2023/06/14.
//

import UIKit

class PaddedLabel: UILabel {
    var inset: UIEdgeInsets
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    init(inset: UIEdgeInsets) {
        self.inset = inset
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += inset.top + inset.bottom
        contentSize.width += inset.left + inset.right
        return contentSize
    }
}

class RoundedPaddedLabel: PaddedLabel {
    init(radius: CGFloat, inset: UIEdgeInsets) {
        super.init(inset: inset)
        setRadius(radius: .roundedRectangle)
    }
}

final class PillShapePaddedLabel: PaddedLabel {
    // TODO: layoutSubviews 대안 찾기
    override func layoutSubviews() {
        super.layoutSubviews()
        setRadius()
    }
    
    func setRadius() {
        setRadius(constant: frame.height / 2)
    }
}
