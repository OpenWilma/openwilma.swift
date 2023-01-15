//
//  Schedule.swift
//  
//
//  Created by Ruben Mkrtumyan on 15.1.2023.
//

import Foundation

public extension OpenWilma {
    static func getSchedule(_ wilmaSession: WilmaSession, date: Date = Date()) async throws -> WilmaSchedule  {
        var currentRole = try? wilmaSession.getRole()
        if currentRole == nil {
            currentRole = try await getActiveRole(wilmaSession, roleRequired: false)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateUtils.yearMonthDay)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "schedule/export/\(currentRole!.type == .guardian ? UserType.student.rawValue : currentRole!.type.rawValue)s/\(currentRole!.primusId)/index_json?date=\(DateUtils.finnish.string(from: date))", requireRole: false), wilmaSession: wilmaSession).serializingDecodable(ScheduleResponse.self, decoder: decoder).value
        
        if let error = response.error {
            throw error
        }
        
        return WilmaScheduleReformatter.reformatSchedule(response, date)
    }
    
    static func getScheduleRange(_ wilmaSession: WilmaSession, _ start: Date, _ end: Date) async throws -> WilmaSchedule {
        var days: [ScheduleDay] = []
        var terms: [Term] = []
        for week in DateUtils.splitWeeksFromRange(start, end) {
            let schedule = try? await getSchedule(wilmaSession, date: week)
            days.append(contentsOf: schedule?.days ?? [])
            if !(schedule?.terms ?? []).isEmpty && terms.isEmpty {
                terms.removeAll()
                terms.append(contentsOf: schedule?.terms ?? [])
            }
        }
        return WilmaSchedule(days: days, terms: terms)
    }
}
