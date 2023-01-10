//
//  JSONDateUtils.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

struct JSONDateUtils {
    
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
    
    static let finnishTime: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    static let finnishFormatted: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    static let time: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
}

extension Date {
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
