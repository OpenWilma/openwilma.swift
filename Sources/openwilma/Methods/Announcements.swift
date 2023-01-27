//
//  Announcements.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

public extension OpenWilma {
    
    static func getAnnouncements(_ wilmaSession: WilmaSession) async throws -> [Announcement]  {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "news?printable&format=json&LangID=1"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let responseString = response.value else {
            return []
        }
        return try WilmaAnnouncementsParser.parseAnnouncements(responseString)
    }
    
    static func getAnnouncement(_ wilmaSession: WilmaSession, _ id: Int) async throws -> Announcement?  {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "news/\(id)?printable&format=json&LangID=1"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let responseString = response.value else {
            return nil
        }
        return try WilmaAnnouncementsParser.parseAnnouncement(responseString)
    }
    
}
