//
//  WilmaSchool.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.12.2022.
//

import Foundation

public struct WilmaSchool: Codable, Hashable {
    public var id: Int
    public var name: String
    public var features: [String]? = []
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case id
        case features
        case name = "caption"
    }
}
