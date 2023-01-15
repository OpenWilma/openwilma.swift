//
//  WilmaExamsParser.swift
//  
//
//  Created by Ruben Mkrtumyan on 6.1.2023.
//

import Foundation
import SwiftSoup

struct WilmaExamsParser {

    private static let dateRegex = try! NSRegularExpression(pattern: #"[0-9]+\.[0-9]+\.[0-9]+"#, options: [])
    
    static func parse(_ htmlDocument: String) throws -> [Exam] {
        let doc: Document = try SwiftSoup.parse(htmlDocument)
        let examTables = try doc.getElementsByClass("table table-grey")
        
        var exams: [Exam] = []
        
        for examTable in examTables {
            let dataPoints = try examTable.getElementsByTag("td")
            
            let dateAndTime = dataPoints.first(where: {$0.hasClass("col-lg-3 col-md-3") && ((try? $0.getElementsByClass("badge"))?.isEmpty()) == true})
            let titleSplit = try? dateAndTime?.nextElementSibling()?.text().components(separatedBy: " : ")
            let creators = try examTable.getElementsByClass("ope").map {WilmaTeacher(
                primusId: try? $0.attr("href").split(separator: "/").last?.toInt(),
                codeName: String(try $0.text().split(separator: "(").first!).trimmingCharacters(in: .whitespacesAndNewlines),
                fullName: String(try $0.text().split(separator: "(").last!.split(separator: ")").first!)
            )}
            let details = dataPoints.last()
            
            var timestamp: Date? = nil
            
            timestamp = try? DateUtils.finnishTime.date(from: dateAndTime?.text().lowercased() ?? "")
            if timestamp == nil, let dateValue = try? dateAndTime?.text().lowercased() {
                let backupTimestamp = dateRegex.firstMatch(in: dateValue, range: NSRange(dateValue.startIndex..<dateValue.endIndex, in: dateValue)).map({String(dateValue[Range($0.range, in: dateValue)!])})
                timestamp = DateUtils.finnishFormatted.date(from: String(backupTimestamp ?? ""))
            }
            
            var subject: String?, courseCode: String?, courseName: String?, grade: String?, verbalGrade: String?
            
            if titleSplit?.count == 3 {
                subject = titleSplit?[0]
                courseCode = titleSplit?[1].trimmingCharacters(in: .whitespacesAndNewlines)
                courseName = titleSplit?[2]
            } else if titleSplit?.count == 2 {
                courseCode = titleSplit?[0].trimmingCharacters(in: .whitespacesAndNewlines)
                courseName = titleSplit?[1]
            }
            
            if dataPoints.count > 4 {
                let teacherField = try? examTable.getElementsByClass("profile-link").first()?.parent()?.parent()
                if dataPoints.count > 5 {
                    grade = try? teacherField?.nextElementSibling()?.getElementsByTag("td").text()
                    verbalGrade = try? teacherField?.nextElementSibling()?.nextElementSibling()?.getElementsByTag("td").text()
                } else {
                    grade = try? teacherField?.nextElementSibling()?.text()
                }
            }
            
            exams.append(Exam(timestamp: timestamp, teachers: creators, courseCode: courseCode, courseName: courseName, subject: subject, additionalInfo: try? details?.text(trimAndNormaliseWhitespace: false), grade: grade, verbalGrade: verbalGrade))
        }
        
        return exams
    }
    
    static func parsePast(_ htmlDocument: String) throws -> [Exam] {
        let doc: Document = try SwiftSoup.parse(htmlDocument)
        let examTable = try doc.getElementById("examtable")
        
        var exams: [Exam] = []
        
        if let examRows = try? examTable?.getElementsByTag("tbody").first()?.getElementsByTag("tr") {
            for examRow in examRows {
                let dataPoints = try? examRow.getElementsByTag("td")
                
                let dateAndTime = dataPoints?.first()
                let titleSplit = try? dataPoints?[2].text().components(separatedBy: " : ")
                let creators = try examRow.getElementsByClass("profile-link").map {WilmaTeacher(
                    primusId: try? $0.attr("href").split(separator: "/").last?.toInt(),
                    codeName: try $0.text().trimmingCharacters(in: .whitespacesAndNewlines),
                    fullName: (try $0.attr("title"))
                )}
                let details = try? dataPoints?.last()?.previousElementSibling()?.previousElementSibling()
                
                var timestamp: Date?
                
                if let dateValue = try? dateAndTime?.text().lowercased() {
                    let timestampResult = dateRegex.firstMatch(in: dateValue, range: NSRange(dateValue.startIndex..<dateValue.endIndex, in: dateValue)).map({String(dateValue[Range($0.range, in: dateValue)!])})
                    timestamp = DateUtils.finnishFormatted.date(from: String(timestampResult ?? ""))
                }
                
                var subject: String?, courseCode: String?, courseName: String?
                let grade = try? dataPoints?.last()?.previousElementSibling()?.text()
                let verbalGrade = try? dataPoints?.last()?.text()
                
                if titleSplit?.count == 3 {
                    subject = titleSplit?[0]
                    courseCode = titleSplit?[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    courseName = titleSplit?[2]
                } else if titleSplit?.count == 2 {
                    courseCode = titleSplit?[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    courseName = titleSplit?[1]
                }
                
                exams.append(Exam(timestamp: timestamp, teachers: creators, courseCode: courseCode, courseName: courseName, subject: subject, additionalInfo: try? details?.text(trimAndNormaliseWhitespace: false), grade: grade, verbalGrade: verbalGrade))

            }
        }
        
        return exams
    }
}
