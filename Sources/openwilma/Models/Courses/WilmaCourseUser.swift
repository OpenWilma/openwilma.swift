//
//  WilmaCourseUser.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

public struct WilmaCourseUser: Codable, Hashable {
    public let id: Int
    public let firstName: String?
    public let lastName: String?
    
    public init(from decoder: Decoder) throws {
        let keyMap = [
            "id": ["id"],
            "firstName": ["firstname", "firstName"],
            "lastName": ["lastname", "lastName"]
        ]
        let container = try decoder.container(keyedBy: AnyKey.self)
        self.id = try! container.decode(Int.self, forMappedKey: "id", in: keyMap)
        self.firstName = try? container.decode(String?.self, forMappedKey: "firstName", in: keyMap)
        self.lastName = try? container.decode(String?.self, forMappedKey: "lastName", in: keyMap)
    }
}
