//
//  ErrorType.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

public enum OpenWilmaErrorType: Int {
    case Unknown = -1
    case NetworkError = 0
    case InvalidContent = 1
    case WilmaError = 2
    case NoContent = 3
    case LoginError = 4
    case RoleRequired = 5
    case ExpiredSession = 6
    case MFARequired = 7
    case UnsupportedServer = 8
}

extension OpenWilmaErrorType: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let intValue = try? container.decode(Int.self, forKey: .rawValue)
        guard let intValue = intValue, let type = OpenWilmaErrorType(rawValue: intValue) else {
            throw CodingError.unknownValue
        }
        self = type
    }
     
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.rawValue, forKey: .rawValue)
    }
    
}
