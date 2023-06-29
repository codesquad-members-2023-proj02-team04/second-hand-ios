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
    
    private func decodeJson<T: Decodable>(type: T.Type, fromJson data: Data) -> T? {
        var result: T? = nil
        do {
            result = try JSONDecoder().decode(type, from: data)
        } catch {
#if DEBUG
            print(error)
#endif
        }
        return result
    }
    
    private func encodeJson<T: Encodable>(data: T) -> Data? {
        var json: Data? = nil
        do {
            json = try JSONEncoder().encode(data)
        } catch {
#if DEBUG
            print(error)
#endif
        }
        return json
    }
    
    private func makePath(with pathItems: [String]) -> String {
        let base = APICredential.baseURL
        return pathItems.reduce(base) { partial, item in partial + "/\(item)" }
    }
}

extension NetworkManager {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Authorization {
        case existing
        case temp(JWToken)
        case none
    }
    
    static let defaultTimeoutInterval: TimeInterval = 15
    
    func get(
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
        request.httpMethod = HTTPMethod.get.rawValue
        request.timeoutInterval = Self.defaultTimeoutInterval
        
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
}

extension NetworkManager {
    func getJWT(from data: Data) throws -> String {
        guard let finalJWTResponse = decodeJson(type: Response<String>.self, fromJson: data) else {
            throw NetworkError.failToDecodeJWT
        }
        
#if DEBUG
        dump(finalJWTResponse)
#endif
        
        guard let result = finalJWTResponse.data else {
            throw NetworkError.invalidData
        }
        return result
    }
}

// MARK: - Util

extension NetworkManager {
    func requestJWT(with authCode: String) async throws -> JWToken {
        do {
            let (data, response) = try await get(
                path: ["api", "login"],
                queries: ["code": authCode, "clientType": "ios"],
                authorized: .none
            )
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            #if DEBUG
            print(response.statusCode)
            #endif
            
            let jwtValue = try getJWT(from: data)
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
        let urlString = APICredential.baseURL + "/api/signup"
        guard let url = URL(string: urlString) else { throw NetworkError.unDefinedError }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(tempJWT.value)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodeJson(data: data)
        request.timeoutInterval = 15
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponseOrNotHTTPResponse
            }
#if DEBUG
            print(response.statusCode)
#endif
            
            switch response.statusCode {
            case 200:
                do {
                    let finalJWTString = try getJWT(from: data)
                    return JWToken(kind: .final, value: finalJWTString)
                } catch {
                    throw error
                }
            case 400:
                throw NetworkError.failToPost
            default:
                throw NetworkError.unDefinedError
            }
        } catch {
            throw error
        }
    }
    
    func validateJWT(_ jwt: JWToken) async throws -> Bool {
        let urlString = APICredential.baseURL + "/api/user/validateToken"
        guard let url = URL(string: urlString) else { throw NetworkError.unDefinedError }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(jwt.value)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15
        
        do {
            let (_, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponseOrNotHTTPResponse
            }
            #if DEBUG
            print(response.statusCode)
            #endif
            
            switch response.statusCode {
            case 200:
                return true
            default:
                return false
            }
        } catch {
            throw error
        }
    }
}
