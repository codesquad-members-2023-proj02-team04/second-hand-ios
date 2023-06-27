//
//  MyAccountViewController.swift
//  Daangn
//
//  Created by ilim on 2023/06/13.
//

import UIKit

final class MyAccountViewController: UIViewController {
    private let manager = NetworkManager()
    
    private let border = BorderLine(height: 1)
    
    private let profileImageButton = ProfileImageButton()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: FontStyle.headline, color: ColorStyle.black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logOutButton = LoginButton(status: .logout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내 계정"
        view.backgroundColor = ColorStyle.white
        setLayout()
        setButtons()
        setInfo()
    }
    
    private func setLayout() {
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            border.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        view.addSubview(profileImageButton)
        NSLayoutConstraint.activate([
            profileImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImageButton.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 150),
        ])
        
        view.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 24),
            userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        view.addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
        ])
    }
    
    private func setButtons() {
        profileImageButton.setAction(target: nil, #selector(selectPhoto))
        logOutButton.addTarget(nil, action: #selector(logout), for: .touchUpInside)
    }
}

extension MyAccountViewController {
    @objc func setInfo() {
        guard let user = AuthManager().getUserInfo() else { return }
        print(user.profileImageURLString)
        let image = UIImage()
        self.profileImageButton.setImage(image: image)
        self.userNameLabel.text = user.userName
    }
    
    @objc func selectPhoto() {
        let vc = UIViewController()
        let navi = UINavigationController(rootViewController: vc)
        navi.view.backgroundColor = .systemBackground
        self.present(navi, animated: true)
    }
    
    @objc func logout() {
        let title = "알림"
        let message = "정말 로그아웃하시겠어요?"
        let alert = UIAlertController(
            title: title,
            message: message,
            okAction: { _ in AuthManager().logout() }
        )
        self.present(alert, animated: true)
    }
}
