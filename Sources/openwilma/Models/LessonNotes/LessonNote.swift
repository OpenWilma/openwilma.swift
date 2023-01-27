//
//  LessonNote.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public struct LessonNote: Codable, Hashable {
    public let id: Int?
    public var clarificationId: Int?
    public let noteCodename: String?
    public let noteName: String?
    public let discName: String?
    public let courseCode: String?
    public let courseName: String?
    public let authorCodeName: String?
    public let authorName: String?
    public let additionalInfo: String?
    public let backgroundColor: String?
    public let foregroundColor: String?
    public let noteStart: Date?
    public let noteEnd: Date?
    public let duration: Int?
    public let clarifiedBy: String?
    public var needsClarification: Bool = false
}
