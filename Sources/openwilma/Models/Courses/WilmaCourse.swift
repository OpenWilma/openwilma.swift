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
    public let teachers:[WilmaCourseUser]?
    public var additionalInfo: WilmaCourseInfo?
}
