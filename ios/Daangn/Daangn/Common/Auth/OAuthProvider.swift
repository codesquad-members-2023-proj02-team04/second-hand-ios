//
//  OAuthProvider.swift
//  Daangn
//
//  Created by Effie on 2023/06/26.
//

import Foundation

enum OAuthProvider {
    case github
    
    private var clientID: String {
        switch self {
        case .github: return "Iv1.b4d6fbb2a8c02670"
        }
    }
    
    var providerURL: URL? {
        let urlString: String
        switch self {
        case .github: urlString = "https://github.com/login/oauth/authorize?client_id=\(self.clientID)"
        }
        return URL(string: urlString)
    }
}
