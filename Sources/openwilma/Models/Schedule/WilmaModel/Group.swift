//
//  Group.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public struct Group: Codable, Hashable {
    public var id: Int? = 0
    public var courseId: Int? = 0
    public var courseName: String? = nil
    public var courseCode: String? = nil
    public var name: String? = nil
    public var caption: String? = nil
    public var shortCaption: String? = nil
    public var longCaption: String? = nil
    public var fullCaption: String? = nil
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    public var isCommitted: Bool = false
    public var teachers: [ScheduleResource]? = nil
    public var rooms: [ScheduleResource] = []
    
    // Original JSON keys from Wilma JSON response
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case courseId = "CourseId"
        case courseName = "CourseName"
        case courseCode = "CourseCode"
        case name = "Name"
        case caption = "Caption"
        case shortCaption = "ShortCaption"
        case longCaption = "LongCaption"
        case fullCaption = "FullCaption"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case isCommitted = "Committed"
        case teachers = "Teachers"
        case rooms = "Rooms"
    }
}
