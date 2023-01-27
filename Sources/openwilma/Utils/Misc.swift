//
//  Misc.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

extension String {

    func replacingRegex(
        matching pattern: String,
        findingOptions: NSRegularExpression.Options = .caseInsensitive,
        replacingOptions: NSRegularExpression.MatchingOptions = [],
        with template: String
    ) throws -> String? {

        let regex = try NSRegularExpression(pattern: pattern, options: findingOptions)
        let range = NSRange(startIndex..., in: self)
        let result = regex.stringByReplacingMatches(in: self, options: replacingOptions, range: range, withTemplate: template)
        return result.isEmpty ? nil : result
    }
    
    func toInt() -> Int? {
      var result: Int? = nil
      if let i = Int(self) {
          result = i
      }
      return result
    }
 }

extension Substring {
    
    func toInt() -> Int? {
      var result: Int? = nil
      if let i = Int(String(self)) {
          result = i
      }
      return result
    }
    
    func toString() -> String? {
      return String(self)
    }
    
}

extension String.Element {

    func replacingRegex(
        matching pattern: String,
        findingOptions: NSRegularExpression.Options = .caseInsensitive,
        replacingOptions: NSRegularExpression.MatchingOptions = [],
        with template: String
    ) throws -> String? {

        let regex = try NSRegularExpression(pattern: pattern, options: findingOptions)
        let range = NSRange(String(self).startIndex..., in: String(self))
        let result = regex.stringByReplacingMatches(in: String(self), options: replacingOptions, range: range, withTemplate: template)
        return result.isEmpty ? nil : result
    }
 }
