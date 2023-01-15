//
//  JSONDateUtils.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

struct DateUtils {
    
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
    
    static let finnish: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    static let time: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    static func splitWeeksFromRange(_ start: Date, _ end: Date) -> [Date] {
        var dates: [Date] = []
        var date = start.startOfWeek!
        while date <= end {
            date = date.next(.monday)
            dates.append(date)
        }
        return dates
    }
}

extension Date {
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "Europe/Helsinki") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)

        components.timeZone = TimeZone(identifier: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        components.year = components.year
        components.month = components.month
        components.day = components.day
        return cal.date(from: components)
    }
    
    public func mergeDateAndTime(_ time: Date, timeZoneAbbrev: String = "Europe/Helsinki") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        var timeCompoennts = cal.dateComponents(x, from: time)

        components.timeZone = TimeZone(identifier: timeZoneAbbrev)
        components.hour = timeCompoennts.hour
        components.minute = timeCompoennts.minute
        components.second = timeCompoennts.second
        components.year = components.year
        components.month = components.month
        components.day = components.day
        return cal.date(from: components)
    }

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }
    
  func addDays(days: Int = 1) -> Date? {
    return Calendar.current.date(byAdding: .day, value: days, to: self)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
        
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func getCombinedWeekNumber() -> Int {
        let beginComponents = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        return (beginComponents.yearForWeekOfYear ?? 0) + (beginComponents.weekOfYear ?? 0)
    }
    
    func getWeekOfYear() -> Int {
        let beginComponents = Calendar.current.dateComponents([.weekOfYear], from: self)
        return beginComponents.weekOfYear ?? 0
    }
    
    func getWeekDay() -> Int {
        let beginComponents = Calendar(identifier: .gregorian).dateComponents([.weekday, .weekdayOrdinal], from: self)
        return beginComponents.weekday ?? 0
    }
    
    func getMonth() -> Int {
        let beginComponents = Calendar(identifier: .gregorian).dateComponents([.month], from: self)
        return beginComponents.month ?? 0
    }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}
