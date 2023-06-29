//
//  NetworkManager.swift
//  Daangn
//
//  Created by Effie on 2023/06/20.
//

import Foundation

// MARK: NetworkManager

typealias RequestParameters = [String: String]

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private func makePath(with pathItems: [String]) -> String {
        let base = APICredential.baseURL
        return pathItems.reduce(base) { partial, item in partial + "/\(item)" }
    }
}

extension NetworkManager {
    enum HTTPMethod {
        case get
        case post(data: Encodable)
        
        var method: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            }
        }
    }
    
    enum Authorization {
        case existing
        case temp(JWToken)
        case none
    }
    
    static let defaultTimeoutInterval: TimeInterval = 15
    
    private func httpRequest(
        method: HTTPMethod,
        path: [String] = [],
        queries: RequestParameters = [:],
        authorized: Authorization = .existing
    ) async throws -> (data: Data, response: URLResponse) {
        let urlString = makePath(with: path)
        guard var urlcomponent = URLComponents(string: urlString) else { throw NetworkError.unDefinedError }
        let queryItems = queries.map { item in URLQueryItem(name: item.key, value: item.value) }
        urlcomponent.queryItems = queryItems
        guard let url = urlcomponent.url else { throw NetworkError.unDefinedError }
        var request = URLRequest(url: url)
        request.timeoutInterval = Self.defaultTimeoutInterval
        request.httpMethod = HTTPMethod.get.method
        
        switch method {
        case .get:
            request.httpMethod = HTTPMethod.get.method
        case .post(let data):
            request.httpMethod = HTTPMethod.post(data: data).method
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(data)
        }
        
        switch authorized {
        case .existing:
            guard let token = AuthManager().token else { break }
            request.addValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")
        case .temp(let tempToken):
            request.addValue("Bearer \(tempToken.value)", forHTTPHeaderField: "Authorization")
        case .none:
            break
        }
        return try await session.data(for: request)
    }
    
    private func get(
        path: [String] = [],
        queries: RequestParameters = [:],
        authorized: Authorization = .existing
    ) async throws -> (data: Data, response: URLResponse) {
        try await httpRequest(method: .get, path: path, queries: queries, authorized: authorized)
    }
    
    private func post<PostData: Encodable>(
        data: PostData,
        path: [String] = [],
        queries: RequestParameters = [:],
        authorized: Authorization = .existing
    ) async throws -> (data: Data, response: URLResponse) {
        try await httpRequest(method: .post(data: data), path: path, queries: queries, authorized: authorized)
    }
}

extension NetworkManager {
    private func decodeAndGetJWT(from data: Data) throws -> String {
        let finalJWTResponse = try JSONDecoder().decode(Response<String>.self, from: data)
        guard let result = finalJWTResponse.data else {
            throw NetworkError.invalidData
        }
        return result
    }
}

// MARK: - Util

extension NetworkManager {
    func getJWT(with authCode: String) async throws -> JWToken {
        do {
            let (data, response) = try await get(
                path: ["api", "login"],
                queries: ["code": authCode, "clientType": "ios"],
                authorized: .none
            )
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            print(response.statusCode)
            
            let jwtValue = try decodeAndGetJWT(from: data)
            switch response.statusCode {
            case 200: return JWToken(kind: .final, value: jwtValue)
            case 302: return JWToken(kind: .temp, value: jwtValue)
            default: throw NetworkError.unDefinedError
            }
        } catch {
            throw error
        }
    }
    
    func postSignUpInfo<RequestData: Encodable>(
        tempJWT: JWToken,
        data: RequestData
    ) async throws -> JWToken {
        let (data, response) = try await post(
            data: data,
            path: ["api", "signup"],
            authorized: .temp(tempJWT)
        )
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponseOrNotHTTPResponse
        }
        
        print(response.statusCode)
        switch response.statusCode {
        case 200:
            let finalJWTString = try decodeAndGetJWT(from: data)
            return JWToken(kind: .final, value: finalJWTString)
        case 400:
            throw NetworkError.failToPost
        default:
            throw NetworkError.unDefinedError
        }
    }
    
    func validateJWT(_ jwt: JWToken) async throws -> Bool {
        let (_, response) = try await get(
            path: ["api", "user", "validateToken"],
            authorized: .temp(jwt)
        )
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponseOrNotHTTPResponse
        }
        print(response.statusCode)
        return response.statusCode == 200 ? true : false
    }
}
