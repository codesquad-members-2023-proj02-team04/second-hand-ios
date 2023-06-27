//
//  TabBarController.swift
//  Daangn
//
//  Created by Effie on 2023/06/11.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        view.backgroundColor = ColorStyle.gray50
    }
    
    private func setViewControllers() {
        let homeNavigationController = createNavigationController(with: HomeViewController(), title: "홈화면", tabBarIconName: "house")
        let salesNavigationController = createNavigationController(with: SalesViewController(), title: "판매내역", tabBarIconName: "newspaper")
        let watchNavigationController = createNavigationController(with: WatchlistViewController(), title: "관심목록", tabBarIconName: "heart")
        let chatNavigationController = createNavigationController(with: ChatListViewController(), title: "채팅", tabBarIconName: "message")
        let accountNavigationController = createNavigationController(with: MyAccountViewController(), title: "내 계정", tabBarIconName: "person")
        
        let controllers: [UIViewController] = [
            homeNavigationController, salesNavigationController, watchNavigationController, chatNavigationController, accountNavigationController,
        ]
        setViewControllers(controllers, animated: false)
    }
    
    private func createNavigationController(with viewController: UIViewController, title: String, tabBarIconName: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = generateStyledImage(systemName: tabBarIconName)
        return navigationController
    }
    
    private func generateStyledImage(systemName name: String) -> UIImage? {
        let tintColor = ColorStyle.black ?? .black
        return UIImage(systemName: name)?.withTintColor(tintColor).applyingSymbolConfiguration(.init(scale: .medium))
    }
}
