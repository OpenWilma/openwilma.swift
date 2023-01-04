//
//  SessionResponse.swift
//  
//
//  Created by Ruben Mkrtumyan on 3.1.2023.
//

import Foundation

public struct SessionResponse: JSONErrorResponse {
    public var error: WilmaError?
    
    public let sessionId: String
    public let apiVersion: Int
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case sessionId = "SessionID"
        case apiVersion = "ApiVersion"
    }
}
