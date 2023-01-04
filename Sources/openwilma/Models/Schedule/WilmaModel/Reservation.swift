//
//  Reservation.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public struct Reservation: Codable, Hashable {
    public var reservartionId: Int
    public var scheduleId: Int
    public var day: Int
    public var start: String
    public var startDate: Date
    public var endDate: Date
    public var end: String
    public var color: String
    public var wilmaClass: String
    public var isAllowEdit: Bool
    public var isAllowAddMoveRemove: Bool
    public var groups: [Group]
    public var dates: [Date]? = nil
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case reservartionId = "ReservationID"
        case scheduleId = "ScheduleID"
        case day = "Day"
        case start = "Start"
        case startDate = "startDate"
        case endDate = "endDate"
        case end = "End"
        case color = "Color"
        case wilmaClass = "Class"
        case isAllowEdit = "AllowEdit"
        case isAllowAddMoveRemove = "AllowAddMoveRemove"
        case groups = "Groups"
        case dates = "Dates"
    }
}
