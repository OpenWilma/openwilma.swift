//
//  WilmaHomework.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

public struct WilmaHomework: Codable, Hashable {
    let date: Date?
    let caption: String?
    
    public init(from decoder: Decoder) throws {
        let keyMap = [
            "date": ["date"],
            "caption": ["lesson", "note"]
        ]
        let container = try decoder.container(keyedBy: AnyKey.self)
        self.date = try! container.decodeStringDate(DateUtils.nonStandard, forMappedKey: "date", in: keyMap)
        self.caption = try? container.decode(String?.self, forMappedKey: "caption", in: keyMap)
    }
}
