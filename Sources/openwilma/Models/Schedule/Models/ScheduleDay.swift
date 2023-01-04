//
//  ScheduleDay.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public struct ScheduleDay: Codable, Hashable {
    public var reservations: [Reservation]
    public var date: Date
}
