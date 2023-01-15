//
//  WilmaCourseExam.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

public struct WilmaCourseExam: Codable, Hashable {
    public let id: Int
    public let date: Date
    public let caption: String?
    public let topic: String?
    public let timeStart: Date?
    public let timeEnd: Date?
    public let grade: String?
    public let verbalGrade: String?
    
    public init(from decoder: Decoder) throws {
        let keyMap = [
            "id": ["id"],
            "date": ["date"],
            "caption": ["caption"],
            "topic": ["topic"],
            "timeStart": ["timeStart"],
            "timeEnd": ["timeEnd"],
            "grade": ["grade"],
            "verbalGrade": ["verbalGrade"],
        ]
        let container = try decoder.container(keyedBy: AnyKey.self)
        self.id = try! container.decode(Int.self, forMappedKey: "id", in: keyMap)
        self.date = try! container.decodeStringDate(DateUtils.yearMonthDay, forMappedKey: "date", in: keyMap)!
        self.caption = try? container.decode(String?.self, forMappedKey: "caption", in: keyMap)
        self.topic = try? container.decode(String?.self, forMappedKey: "topic", in: keyMap)
        self.timeStart = try! container.decodeStringDate(DateUtils.time, forMappedKey: "timeStart", in: keyMap)
        self.timeEnd = try! container.decodeStringDate(DateUtils.time, forMappedKey: "timeEnd", in: keyMap)
        self.grade = try? container.decode(String?.self, forMappedKey: "grade", in: keyMap)
        self.verbalGrade = try? container.decode(String?.self, forMappedKey: "verbalGrade", in: keyMap)
    }
}
