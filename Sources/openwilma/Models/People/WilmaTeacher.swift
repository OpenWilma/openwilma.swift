//
//  WilmaTeacher.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public struct WilmaTeacher: Codable, Hashable {
    public let primusId: Int?
    public let codeName: String
    public let fullName: String
    public var firstName: String? = nil
    public var lastName: String? = nil
}

