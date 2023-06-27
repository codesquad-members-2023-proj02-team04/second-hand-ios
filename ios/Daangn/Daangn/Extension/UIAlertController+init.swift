//
//  UIAlertController+init.swift
//  Daangn
//
//  Created by Effie on 2023/06/27.
//

import UIKit

extension UIAlertController {
    convenience init(title: String, message: String, okAction: @escaping (UIAlertAction) -> Void) {
        self.init(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        self.addAction(cancleAction)
        self.addAction(okAction)
    }
}
