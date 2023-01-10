//
//  WilmaCourseInfo.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

public struct WilmaCourseInfo: Codable, Hashable {
    public let id: Int
    public let caption: String
    public let description: String?
    public let abbreviation: String?
    public let scope: WilmaCourseScope?
}
