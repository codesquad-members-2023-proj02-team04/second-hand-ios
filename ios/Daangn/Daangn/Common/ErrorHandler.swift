//
//  ErrorHandler.swift
//  Daangn
//
//  Created by Effie on 2023/06/26.
//

import UIKit

class ErrorHandler {
    static func alertError(_ error: Error, presentOn presenter: UIViewController) {
        let title = "알림"
        let message = error.localizedDescription
        let alert = UIAlertController(
            title: title,
            message: message) { _ in }
        presenter.present(alert, animated: true)
    }
}
