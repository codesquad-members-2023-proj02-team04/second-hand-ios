//
//  Response.swift
//  Daangn
//
//  Created by Effie on 2023/06/29.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T?
}
