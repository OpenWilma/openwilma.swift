//
//  Exam.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public struct Exam: Codable, Hashable {
    public let timestamp: Date?
    public let teachers: [WilmaTeacher]?
    public let courseCode: String?
    public let courseName: String?
    public let subject: String?
    public let additionalInfo: String?
    public let grade: String?
    public let verbalGrade: String?
}
