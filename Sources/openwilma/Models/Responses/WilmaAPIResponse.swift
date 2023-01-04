//
//  WilmaAPIResponse.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

public struct WilmaAPIResponse<T: Codable & Hashable>: Codable, Hashable {
    public let statusCode: Int?
    public var error: WilmaError?
    public let payload: T?
}
