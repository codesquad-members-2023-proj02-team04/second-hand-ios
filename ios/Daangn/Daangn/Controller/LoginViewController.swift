//
//  LoginViewController.swift
//  Daangn
//
//  Created by Effie on 2023/06/26.
//

import UIKit

import AuthenticationServices
import JWTDecode

final class LoginViewController: UIViewController {
    private let manager = NetworkManager()
    
    private let daangnImage: UIImageView = {
        let image = UIImage(named: "daangn")
        let view = UIImageView(frame: .zero)
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "당신 근처의 당근마켓"
        label.applyStyle(font: FontStyle.headline, color: ColorStyle.black)
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "중고 거래부터 동네 정보까지,\n지금 내 동네를 선택하고 시작해보세요!"
        label.numberOfLines = 2
        label.applyStyle(font: FontStyle.body, color: ColorStyle.black)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let loginButton = LoginButton(status: .login)
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "Github 계정으로 당근 계정을 만들거나 로그인할 수 있어요"
        label.applyStyle(font: FontStyle.caption1, color: ColorStyle.gray800)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.white
        setLayout()
        setButtons()
    }
    
    private func setLayout() {
        view.addSubview(daangnImage)
        NSLayoutConstraint.activate([
            daangnImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            daangnImage.heightAnchor.constraint(equalTo: daangnImage.widthAnchor),
            daangnImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            daangnImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
        ])
        
        view.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelStack.topAnchor.constraint(equalTo: daangnImage.bottomAnchor, constant: 15),
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        view.addSubview(noticeLabel)
        NSLayoutConstraint.activate([
            noticeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noticeLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
        ])
    }
    
    private func setButtons() {
        loginButton.addTarget(nil, action: #selector(loginWithGithub), for: .touchUpInside)
    }
}

extension LoginViewController {
    @objc func loginWithGithub() {
        let scheme = "daangn"
        guard let githubAuthURL = OAuthProvider.github.providerURL else { return }
        let session = ASWebAuthenticationSession(
            url: githubAuthURL,
            callbackURLScheme: scheme
        ) { [weak self] callbackURL, error in
            guard let self else { return }
            
            if let error {
                ErrorHandler.alertError(error, presentOn: self)
                return
            }
            
            guard let callbackURL else {
                ErrorHandler.alertError(NetworkError.unDefinedError, presentOn: self)
                return
            }
            
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let authCode = queryItems?.first { $0.name == "code" }?.value
            
            guard let authCode else {
                ErrorHandler.alertError(NetworkError.authCodeIsNil, presentOn: self)
                return
            }
            
            Task { [weak self] in
                guard let self else { return }
                do {
                    let jwt = try await self.manager.requestJWT(with: authCode)
                    switch jwt.kind {
                    case .final:
                        AuthManager().saveToken(jwt)
                    case .temp:
                        let tempInfo = SignUpTempInfo(jwt: jwt)
                        let signupViewController = CreateAccountViewController(tempInfo: tempInfo)
                        let navigationController = UINavigationController(rootViewController: signupViewController)
                        navigationController.view.backgroundColor = .systemBackground
                        self.present(navigationController, animated: true)
                    }
                } catch {
                    ErrorHandler.alertError(error, presentOn: self)
                }
            }
        }
        
        session.presentationContextProvider = self
        session.start()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let window = view.window else {
            fatalError("No window found in view")
        }
        return window
    }
}
