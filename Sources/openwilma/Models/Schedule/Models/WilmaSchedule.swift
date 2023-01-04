//
//  WilmaSchedule.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public struct WilmaSchedule: Codable, Hashable {
    public let days: [ScheduleDay]
    public let terms: [Term]
}
