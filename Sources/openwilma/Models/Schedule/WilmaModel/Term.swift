//
//  Term.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public struct Term: Codable, Hashable {
    public let name: String
    public let start: Date
    public let end: Date
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case start = "StartDate"
        case end = "EndDate"
    }
}
