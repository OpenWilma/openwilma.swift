//
//  ScheduleResponse.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.1.2023.
//

import Foundation

public struct ScheduleResponse: JSONErrorResponse {
    public var error: WilmaError?
    
    public let reservations: [Reservation]?
    public let terms: [Term]?
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case reservations = "Schedule"
        case terms = "Terms"
    }
}
