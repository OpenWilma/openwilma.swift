//
//  Exams.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.1.2023.
//

import Foundation

public extension OpenWilma {
    
    static func getUpcomingExams(_ wilmaSession: WilmaSession) async throws -> [Exam] {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "exams/calendar?format=json"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let responseString = response.value else {
            return []
        }
        return try WilmaExamsParser.parse(responseString)
    }
    
    static func getPastExams(_ wilmaSession: WilmaSession, start: Date? = nil, end: Date? = nil) async throws -> [Exam] {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "exams/calendar/past?printable&format=json\((start != nil && end != nil) ? "&range=-3&first=\(DateUtils.finnishFormatted.string(from: start!))&last=\(DateUtils.finnishFormatted.string(from: end!))" : "")"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let responseString = response.value else {
            return []
        }
        return try WilmaExamsParser.parsePast(responseString)
    }
    
}
