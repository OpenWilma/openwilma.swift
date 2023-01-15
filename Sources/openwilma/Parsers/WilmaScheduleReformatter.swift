//
//  WilmaScheduleReformatter.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.1.2023.
//

import Foundation

struct WilmaScheduleReformatter {
    
    private static func getCorrectWeekday(_ weekdayInt: Int) -> Date.Weekday {
        switch (weekdayInt) {
        case 1:
            return .monday
        case 2:
            return .tuesday
        case 3:
            return .wednesday
        case 4:
            return .thursday
        case 5:
            return .friday
        case 6:
            return .saturday
        case 7:
            return .sunday
        default:
            return .monday
        }
    }
    
    static func reformatSchedule(_ schedule: ScheduleResponse, _ date: Date = Date()) -> WilmaSchedule {
        // Monday
        let monday = date.midnight.startOfWeek
        
        var reservations: [TimeInterval: [Reservation]] = [:]
        
        // Making hashmap
        
        for reservation in (schedule.reservations ?? []) {
            var reservation = reservation
            let reservationDay = reservation.day
            let startTime = DateUtils.time.date(from: reservation.start)
            let endTime = DateUtils.time.date(from: reservation.end)
            
            let day = monday?.get(.next, getCorrectWeekday(reservationDay))
            let dayUnix = day?.timeIntervalSince1970
            
            reservation.startDate = day?.mergeDateAndTime(startTime ?? Date()) ?? startTime!
            reservation.endDate = day?.mergeDateAndTime(endTime ?? Date()) ?? endTime!
            
            if let dayUnix = dayUnix {
                if let array = reservations[dayUnix] {
                    var existingArray = array
                    existingArray.append(reservation)
                    reservations[dayUnix] = existingArray
                } else {
                    reservations[dayUnix] = [reservation]
                }
            }
        }
        
        // Creating final result
        
        var days: [ScheduleDay] = []
        for key in reservations.keys {
            days.append(ScheduleDay(reservations: reservations[key]!, date: Date(timeIntervalSince1970: key)))
        }
        
        return WilmaSchedule(days: days, terms: schedule.terms ?? [])
    }
}
