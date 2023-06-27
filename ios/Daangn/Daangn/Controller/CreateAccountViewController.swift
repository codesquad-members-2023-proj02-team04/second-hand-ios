//
//  CreateAccountViewController.swift
//  Daangn
//
//  Created by Effie on 2023/06/16.
//

import UIKit

final class CreateAccountViewController: UIViewController {
    let networkManager = NetworkManager()
    
    // MARK: Views
    private let border = BorderLine(height: 1)
    
    private let profileImageButton = ProfileImageButton()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(font: FontStyle.headline, color: ColorStyle.black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let townButton = TownButton()
    
    // MARK: Properties
    
    private let tempInfo: SignUpTempInfo
    
    // MARK: Initializer
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    init(tempInfo: SignUpTempInfo) {
        self.tempInfo = tempInfo
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    // MARK: Life cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setProfileButton()
        setLayout()
    }
    
    // MARK: Life cycle Methods
    
    private func setNavigationItem() {
        self.title = "회원가입"
        self.navigationItem.leftBarButtonItem = .init(
            title: "닫기",
            style: .plain,
            target: self,
            action: #selector(dismissViewController)
        )
        
        self.navigationItem.rightBarButtonItem = .init(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(save)
        )
    }
    
    private func setProfileButton() {
        profileImageButton.setAction(target: self, #selector(selectPhoto))
    }
    
    private func setLayout() {
        view.addSubview(border)
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        
        view.addSubview(profileImageButton)
        NSLayoutConstraint.activate([
            profileImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
        ])
        
        view.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            userNameLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 24),
        ])
        
        view.addSubview(townButton)
        NSLayoutConstraint.activate([
            townButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            townButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            townButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 40),
        ])
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc func save() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let tempLocation = TempSignUpPostLocation()
                let finalJWT = try await networkManager.postSignUpInfo(tempJWT: tempInfo.jwt, data: tempLocation)
                
                #if DEBUG
                print(finalJWT.value)
                #endif
                
                AuthManager().saveToken(finalJWT)
                self.presentingViewController?.dismiss(animated: true)
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    @objc func selectPhoto() {
        let vc = UIViewController()
        let navi = UINavigationController(rootViewController: vc)
        navi.view.backgroundColor = .systemBackground
        self.present(navi, animated: true)
    }
}

extension CreateAccountViewController {
    private func configure() {
        let profileImage = UIImage()
        profileImageButton.setImage(image: profileImage)
        userNameLabel.text = tempInfo.userName
    }
}
