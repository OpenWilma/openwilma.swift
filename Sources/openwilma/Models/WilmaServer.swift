//
//  WilmaServer.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.12.2022.
//

import Foundation

public struct WilmaServer: Codable, Hashable {
    public let url: String
    public var name: String? = nil
}
