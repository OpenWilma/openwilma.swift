//
//  JSONErrorResponse.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public protocol JSONErrorResponse: Codable, Hashable {
    var error: WilmaError? { get set }
}

public struct JSONErrorResponseModel: JSONErrorResponse {
    public var error: WilmaError?
}
