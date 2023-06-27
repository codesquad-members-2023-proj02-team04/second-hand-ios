//
//  SceneDelegate.swift
//  Daangn
//
//  Created by Effie on 2023/06/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private class InitialViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
        }
    }
    
    var window: UIWindow?
    
    private var windowHandler: WindowHandler?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = InitialViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        self.windowHandler = WindowHandler(window: window)
//        AuthManager().logout()
        setInitialLoginResult()
    }
}

extension SceneDelegate {
    private func setInitialLoginResult() {
        Task { [weak self] in
            guard let self else { return }
            let logInResult = await AuthManager().getLoginResult()
            self.windowHandler?.loginResult = logInResult
        }
    }
}
