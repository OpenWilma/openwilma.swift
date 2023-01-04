//
//  Announcement.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public struct Announcement: Codable, Hashable {
    public let id: Int
    public let subject: String
    public let description: String?
    public let contentHTML: String?
    public let authorName: String?
    public let authorCode: String?
    public let authorId: Int?
    public let authorType: UserType?
    public let timestamp: Date?
    public var important: Bool = false
    public var permanent: Bool = false
}
