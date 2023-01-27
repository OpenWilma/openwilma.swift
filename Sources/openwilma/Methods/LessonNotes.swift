//
//  LessonNotes.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.1.2023.
//

import Foundation

public extension OpenWilma {
    static func getLessonNotes(_ wilmaSession: WilmaSession, _ range: LessonNoteRange = .defaultRange, start: Date? = nil, end: Date? = nil) async throws -> [LessonNote] {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "attendance/view?range=\(range.rawValue)"+(start != nil ? "&first=\(DateUtils.finnishFormatted.string(from: start!))" : "")+(end != nil ? "&last=\(DateUtils.finnishFormatted.string(from: end!))" : "")+"&printable&format=json"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let responseString = response.value else {
            return []
        }
        var allNotes = try WilmaLessonNoteParser.parse(responseString)
        
        let clarifyingResonse = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "attendance/view?printable"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = clarifyingResonse.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let clarifyingResponseString = clarifyingResonse.value else {
            return []
        }
        
        let clarifyingNotes =  try WilmaLessonNoteParser.parse(clarifyingResponseString)
        clarifyingNotes.filter {$0.needsClarification}.forEach {note in
            if let index = allNotes.firstIndex(where: {$0.id == note.id}) {
                allNotes[index].clarificationId = note.clarificationId
                allNotes[index].needsClarification = note.needsClarification
            }
        }
        return allNotes
    }
    
    static func canSaveExcuse(_ wilmaSession: WilmaSession) async throws -> Bool {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "attendance/report?format=json"), wilmaSession: wilmaSession).serializingString().response
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        guard let responseData = response.data else {
            return false
        }
                
        let jsonResult = try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
        
        return jsonResult?["Excuses"] != nil
    }
}
