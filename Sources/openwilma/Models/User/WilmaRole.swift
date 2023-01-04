//
//  WilmaRole.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.12.2022.
//

import Foundation

public struct WilmaRole: Codable, Hashable {
    public var name: String
    public var type: UserType
    public var primusId: Int
    public var slug: String?
    public var formKey: String?
    public var schools: [WilmaSchool]?
    public var profilePicture: String?
}
