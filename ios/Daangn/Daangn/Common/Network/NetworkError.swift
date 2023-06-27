//
//  NetworkError.swift
//  Daangn
//
//  Created by Effie on 2023/06/23.
//

import Foundation

enum NetworkError: Error {
    case noResponse
    case invalidData
    case failToPost
    case failToDelete
    case unknownError
    case noResponseOrNotHTTPResponse
    case failToDecodeJWT
    case failToParse
    case authCodeIsNil
    
    var localizedDescription: String {
        switch self {
        case .invalidData: return "유효하지 않은 데이터입니다."
        case .failToPost: return "데이터 등록에 실패했어요."
        case .failToDelete: return "데이터 삭제에 실패했어요."
        case .noResponse, .noResponseOrNotHTTPResponse: return "네트워크 응답을 받아오는 데 실패했어요."
        case .failToDecodeJWT: return "토큰에서 정보를 추출하는 데 실패했어요."
        case .failToParse: return "받은 데이터 형식이 올바르지 않습니다."
        case .authCodeIsNil: return  "응답으로 받은 코드가 없습니다."
        case .unknownError: return "알 수 없는 에러가 발생했어요."
        }
    }
}
