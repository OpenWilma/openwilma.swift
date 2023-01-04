//
//  WilmaAccountInfo.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.12.2022.
//

import Foundation


public struct WilmaAccountInfo: Codable, Hashable {
    public var primusId: Int
    public var firstName: String
    public var lastName: String
    public var username: String
    public var lastLogin: Date
    public var mfaEnabled: Bool
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case primusId = "id"
        case firstName = "firstname"
        case lastName = "lastname"
        case mfaEnabled = "multiFactorAuthentication"
        
        case lastLogin
        case username
    }
}
