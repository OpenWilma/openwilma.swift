//
//  WilmaError.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public struct WilmaError: Codable, Hashable, OpenWilmaErrorProtocol {
    public var title: String?
    public var code: Int = OpenWilmaErrorType.WilmaError.rawValue
    public var errorType: OpenWilmaErrorType = OpenWilmaErrorType.WilmaError
    public var errorDescription: String?
    public let errorID: String
    public var whatsnext: String
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case title = "message"
        case errorID = "id"
        case whatsnext = "whatnext"
        case errorDescription = "description"
    }
}
