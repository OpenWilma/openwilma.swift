//
//  AnyKey.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

struct AnyKey: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer where K == AnyKey {
    func decode<T>(_ type: T.Type, forMappedKey key: String, in keyMap: [String: [String]]) throws -> T where T : Decodable{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(T.self, forKey: AnyKey(stringValue: key)) {
                return value
            }
        }

        return try decode(T.self, forKey: AnyKey(stringValue: key))
    }
    
    func decodeStringDate(_ dateFormatter: DateFormatter, forMappedKey key: String, in keyMap: [String: [String]], cutTimezoneInfo: Bool = false) throws -> Date?{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(String.self, forKey: AnyKey(stringValue: key)) {
                return dateFormatter.date(from: cutTimezoneInfo ? (String(value.split(separator: "+").first ?? "")) : value)
            }
        }

        return try? decode(Date?.self, forKey: AnyKey(stringValue: key))
    }
    
    func decodeStringDateWithMultipleFormats(_ dateFormatters: [DateFormatter], forMappedKey key: String, in keyMap: [String: [String]], cutTimezoneInfo: Bool = false) throws -> Date?{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(String.self, forKey: AnyKey(stringValue: key)) {
                var date: Date? = nil
                dateFormatters.forEach {formatter in
                    if let formattedDate = formatter.date(from: cutTimezoneInfo ? (String(value.split(separator: "+").first ?? "")) : value) {
                        date = formattedDate
                    }
                }
                return date ?? (try? decode(Date?.self, forKey: AnyKey(stringValue: key)))
            }
        }

        return try? decode(Date?.self, forKey: AnyKey(stringValue: key))
    }
    
    func existsBoolean(forMappedKey key: String, in keyMap: [String: [String]]) -> Bool {
        for key in keyMap[key] ?? [] {
            if contains(AnyKey(stringValue: key)) {
                return true
            }
        }
        return false
    }
}
