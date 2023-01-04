//
//  JSONDateUtils.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

public struct JSONDateUtils {
    
    static let yearMonthDay: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    
    static let standard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    static let nonStandard: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
}
