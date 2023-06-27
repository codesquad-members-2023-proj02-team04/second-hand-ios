//
//  JWT.swift
//  Daangn
//
//  Created by Effie on 2023/06/23.
//

import Foundation
import JWTDecode

struct JWToken {
    enum Kind {
        case temp
        case final
    }
    
    let kind: Kind
    let value: String
    
    private var body: [String: Any] {
        do {
            return try decode(jwt: value).body
        } catch {
            return [:]
        }
    }
    
    init(kind: Kind, value: String) {
        self.value = value
        self.kind = kind
    }
    
    private func value(from key: String) -> Any? {
        return body[key]
    }
    
    func getString(key: String) -> String? {
        let result = value(from: key)
        return result as? String
    }
    
    func getInt(key: String) -> Int? {
        let result = value(from: key)
        return result as? Int
    }
}
