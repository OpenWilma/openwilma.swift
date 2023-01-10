//
//  Courses.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation

public extension OpenWilma {
    
    static func getCourses(_ wilmaSession: WilmaSession, _ timeRange: CourseTimeRange, skipAdditionalInformation: Bool = true) async throws -> WilmaAPIResponse<[WilmaCourse]>  {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(JSONDateUtils.yearMonthDay)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "api/v1/gradebooks/\(timeRange.rawValue)"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<[WilmaCourse]>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        if (!skipAdditionalInformation) {
            var courses: [WilmaCourse] = response.payload ?? []
            for course in courses {
                if let courseId = course.courseId {
                    courses[courses.firstIndex(of: course)!].additionalInfo = try? await getCourseAdditionalInformation(wilmaSession, courseId).payload
                }
            }
            return WilmaAPIResponse(statusCode: response.statusCode, payload: courses)
        }
        return response
    }
    
    static func getCourse(_ wilmaSession: WilmaSession, _ id: Int) async throws -> WilmaAPIResponse<WilmaCourse> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(JSONDateUtils.yearMonthDay)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession.wilmaServer, "api/v1/gradebooks/\(id)"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<WilmaCourse>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        if var course = response.payload, let courseId = course.courseId {
            let additionalInfo = try? await getCourseAdditionalInformation(wilmaSession, courseId)
            course.additionalInfo = additionalInfo?.payload
        }
        return response
    }
    
    static func getCourseAdditionalInformation(_ wilmaSession: WilmaSession, _ id: Int) async throws -> WilmaAPIResponse<WilmaCourseInfo> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(JSONDateUtils.nonStandard)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession.wilmaServer, "api/v1/courses/\(id)"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<WilmaCourseInfo>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        return response
    }
    
    static func getCourseExams(_ wilmaSession: WilmaSession, _ id: Int) async throws -> WilmaAPIResponse<[WilmaCourseExam]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(JSONDateUtils.yearMonthDay)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession.wilmaServer, "api/v1/gradebooks/\(id)/exams"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<[WilmaCourseExam]>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        return response
    }
    
    static func getCourseHomework(_ wilmaSession: WilmaSession, _ id: Int) async throws -> WilmaAPIResponse<[WilmaHomework]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(JSONDateUtils.yearMonthDay)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession.wilmaServer, "api/v1/gradebooks/\(id)/homework"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<[WilmaHomework]>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        return response
    }
    
    /// Notice!
    /// Works only with teacher roles/accounts only!
    static func getCourseStudents(_ wilmaSession: WilmaSession, _ id: Int) async throws -> WilmaAPIResponse<[WilmaCourseUser]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(JSONDateUtils.yearMonthDay)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession.wilmaServer, "api/v1/gradebooks/\(id)/students"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<[WilmaCourseUser]>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        return response
    }
    
}
