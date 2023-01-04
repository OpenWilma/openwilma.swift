//
//  ScheduleResource.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public struct ScheduleResource: Codable, Hashable {
    public let id: Int
    public let codeName: String
    public let name: String
    public let isScheduleVisible: Bool
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case codeName = "Caption"
        case name = "LongCaption"
        case isScheduleVisible = "ScheduleVisible"
    }
}
