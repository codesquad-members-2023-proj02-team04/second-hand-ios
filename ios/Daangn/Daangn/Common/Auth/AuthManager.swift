//
//  AuthManager.swift
//  Daangn
//
//  Created by Effie on 2023/06/24.
//

import Foundation

class AuthManager {
    enum Notifications {
        static let loginSuccessed = Notification.Name("login.successed")
        static let logout = Notification.Name("logout")
    }
    
    private let authKey = "Daangn-jwt-key"
    
    private var networkManager: NetworkManager
    
    var token: JWToken? {
        get {
            guard let tokenValue = KeychainManager.load(key: authKey) else {
                return nil
            }
            return JWToken(kind: .final, value: tokenValue)
        }
        set {
            if let newValue {
                KeychainManager.save(key: authKey, data: newValue.value)
            } else {
                KeychainManager.delete(key: authKey)
            }
        }
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func saveToken(_ token: JWToken) {
        KeychainManager.save(key: authKey, data: token.value)
        postLoginSuccessNotification()
    }
    
    func login() {
        postLoginSuccessNotification()
    }
    
    func logout() {
        KeychainManager.delete(key: authKey)
        postLogoutNotification()
    }
    
    func getLoginResult() async -> LoginResult {
        let networkManager = NetworkManager()
        var result: LoginResult
        if let token = AuthManager().token {
            do {
                let isValidate = try await networkManager.validateJWT(token)
                result = isValidate ? LoginResult.logined : LoginResult.loginNeeded
                if isValidate { login() }
            } catch {
                print(error)
                result = .loginNeeded
            }
        } else {
            result = .loginNeeded
        }
        return result
    }
    
    func getUserInfo() -> UserInfo? {
        guard let token else { return nil }
        
        guard let userID = token.getInt(key: "userId"),
              let userName = token.getString(key: "username"),
              let avatar = token.getString(key: "avatar") else { return nil }
        
        let result = UserInfo(
            userId: userID,
            userName: userName,
            profileImageURLString: avatar
        )
        dump(result)
        return result
    }
}

extension AuthManager {
    private func postLoginSuccessNotification() {
        NotificationCenter.default.post(
            Notification(name: Self.Notifications.loginSuccessed, object: nil)
        )
    }
    
    private func postLogoutNotification() {
        NotificationCenter.default.post(
            Notification(name: Self.Notifications.logout, object: nil)
        )
    }
}
