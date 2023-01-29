//
//  WilmaCourse.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

public struct WilmaCourse: Codable, Hashable {
    public let id: Int
    public let caption: String?
    public let courseId: Int?
    public let name: String?
    public let startDate: Date?
    public let endDate: Date?
    public let committed: Bool
    public let teachers: [WilmaCourseUser]?
    public var additionalInfo: WilmaCourseInfo?
    
    private enum CodingKeys: String, CodingKey {
        case id, caption, courseId, name, startDate, endDate, committed, teachers, additionalInfo
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try! container.decode(Int.self, forKey: .id)
        caption = try? container.decode(String?.self, forKey: .caption)
        courseId = try? container.decode(Int.self, forKey: .courseId)
        name = try? container.decode(String?.self, forKey: .name)
        startDate = try? container.decode(Date?.self, forKey: .startDate)
        endDate = try? container.decode(Date?.self, forKey: .endDate)
        committed = (try? container.decode(Bool.self, forKey: .committed)) ?? false
        teachers = try? container.decode([WilmaCourseUser]?.self, forKey: .teachers)
        additionalInfo = try? container.decode(WilmaCourseInfo?.self, forKey: .additionalInfo)
    }
}
