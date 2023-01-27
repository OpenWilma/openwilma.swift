//
//  WilmaLessonNoteParser.swift
//  
//
//  Created by Ruben Mkrtumyan on 25.1.2023.
//

import Foundation
import SwiftSoup
import SwiftUI
import SwiftCSSParser

public struct WilmaLessonNoteParser {
    
    private static let lessonNoteFullHourWidth = 5.63
    
    private static let decimalRegex = try! NSRegularExpression(pattern: #"[0-9]*[.]?[0-9]+"#, options: [])

    
    static func parse(_ htmlContent: String) throws -> [LessonNote] {
        let doc: Document = try SwiftSoup.parse(htmlContent)
        
        var lessonNotes: [LessonNote] = []
        
        let table = try doc.getElementsByClass("attendance-single").first()
        
        let cssStyling = (try? doc.getElementsByAttributeValue("type", "text/css"))?.first(where: {$0.tagNameNormal() == "style"})
        
        // Parsing colors from CSS rules
        var parsedCSS: Stylesheet?
        if let cssStyling = cssStyling {
            let cleanCSSCode = cssStyling.data().replacingOccurrences(of: "<!--", with: "").replacingOccurrences(of: "-->", with: "").replacingOccurrences(of: "TR TD", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "!important", with: "")
            parsedCSS = try? Stylesheet.parse(from: cleanCSSCode)
        }
        
        var bgColors: [String: String] = [:]
        var fgColors: [String: String] = [:]
        
        for statement in parsedCSS?.statements ?? [] {
            switch statement {
            case .ruleSet(let ruleSet):
                if ruleSet.selector.contains(".at-tp") {
                    let id = ruleSet.selector.split(separator: ",").last!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    let bgColor = ruleSet.declarations.first {$0.property == "background-color" || $0.property == "background"}
                    let fgColor = ruleSet.declarations.first {$0.property == "color"}
                    if let bgValue = bgColor?.value {
                        bgColors[id] = bgValue
                    }
                    if let fgValue = fgColor?.value {
                        fgColors[id] = fgValue
                    }
                }
            default:
              break
            }
        }
        
        if let table = table {
            let tableSpacingConfigs = try? table.getElementsByAttributeValueStarting("style", "width :")
            var tableTimeConfigs = try? table.getElementsByTag("th").array()
            let tableRows = try? table.getElementsByTag("tbody").first()?.getElementsByTag("tr")
            
            // Creating time ranges for lesson note slots
            var lastIndex = 0
            var timeRanges: [TimeRange] = []
            
            // Remove useless columns in table
            tableTimeConfigs?.removeFirst()
            tableTimeConfigs?.removeLast()
            tableTimeConfigs?.removeLast()
            
            for timeConfig in tableTimeConfigs ?? [] {
                let num = (try? timeConfig.text().toInt()) ?? 0
                let colSpan = ((try? timeConfig.attr("colspan"))?.toInt() ?? 1)-1
                var startMinutes = num*60
                var endMinutes = num*60
                for span in 0...colSpan {
                    
                    var startDecimal: Double {
                        let spacingConfig = tableSpacingConfigs?.get(lastIndex+span)
                        let styleAttr = (try? spacingConfig?.attr("style")) ?? ""
                        return Double(decimalRegex.firstMatch(in: styleAttr, range:  NSRange(styleAttr.startIndex..<styleAttr.endIndex, in: styleAttr)).map({String(styleAttr[Range($0.range, in: styleAttr)!])}) ?? "0.0") ?? 0.0
                    }
                    
                    if startDecimal != 1.13 {
                        startMinutes += Int(round(((startDecimal / lessonNoteFullHourWidth) * 60)))
                    }
                    
                    if span < colSpan+1 && lastIndex+span+1 < tableSpacingConfigs?.count ?? 0 {
                        var endDecimal: Double {
                            let spacingConfig = tableSpacingConfigs?.get(lastIndex+span+1)
                            let styleAttr = (try? spacingConfig?.attr("style")) ?? ""
                            return Double(decimalRegex.firstMatch(in: styleAttr, range:  NSRange(styleAttr.startIndex..<styleAttr.endIndex, in: styleAttr)).map({String(styleAttr[Range($0.range, in: styleAttr)!])}) ?? "0.0") ?? 0.0
                        }
                        
                        if endMinutes < startMinutes {
                            endMinutes += startMinutes-endMinutes
                        }
                        
                        endMinutes += Int(round(((endDecimal / lessonNoteFullHourWidth) * 60)))
                    }
                    
                    if startMinutes > endMinutes {
                        continue
                    }
                    
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(identifier: "Europe/Helsinki")!
                    timeRanges.append(TimeRange(start: calendar.date(bySettingHour: Int(floor(Double(startMinutes/60))), minute: startMinutes % 60, second: 0, of: Date().midnight)!, end: calendar.date(bySettingHour: Int(floor(Double(endMinutes/60))), minute: endMinutes % 60, second: 0, of: Date().midnight)!))
                }
                lastIndex += 1+colSpan
            }
                                    
            // Parse lesson notes
            if let tableRows = tableRows {
                var lastDate: Date? = nil
                for note in tableRows {
                    var tableData = try? note.getElementsByTag("td").array()
                    var localDate: Date
                    
                    if (try? tableData?[1].text().isEmpty) == true, let lastDate = lastDate {
                        localDate = lastDate
                    } else {
                        let date = DateUtils.finnishFormatted.date(from: (try? tableData?[1].text()) ?? "")
                        lastDate = date
                        localDate = date ?? Date()
                    }
                    
                    // Parse notices
                    
                    let noticeTexts: [String]? = try? tableData?.last?.getElementsByTag("small").map {item in
                        let _  = try? item.getElementsByClass("lem").remove()
                        return try! item.text()
                    }
                    
                    var noticesMap: [String: String] = [:]
                    noticeTexts?.forEach { notice in
                        let noticeComponents = notice.components(separatedBy: ": ")
                        if let first = noticeComponents.first, let last = noticeComponents.last {
                            noticesMap[first] = last
                        }
                    }
                    
                    tableData?.removeFirst()
                    tableData?.removeFirst()
                    tableData?.removeLast()
                    tableData?.removeLast()
                    var spanCounter = 0
                    var eventCounter = 0
                    for event in tableData ?? [] {
                        
                        let span: Int = (try? event.attr("colspan").toInt()) ?? 1
                        if event.hasClass("event") {
                            
                            let clarificationId: Int? = try? event.getElementsByAttributeValueStarting("name", "item").first()?.attr("name").replacingOccurrences(of: "item", with: "").toInt()
                            
                            let needsClarification = clarificationId != nil
                            
                            // Course info
                            let courseCode: Substring? = try event.attr("title").contains(";") ? event.attr("title").split(separator: ";").first : nil
                            
                            // Teacher info
                            let teacherFullName = try? event.attr("title").components(separatedBy: " - ").first?.split(separator: "/").last
                            let typeIdClass: String? = try? event.classNames().first {name in return name.starts(with: "at-tp") && name.replacingOccurrences(of: "at-tp", with: "").toInt() != nil}
                            
                            // Disc name, comments and teacher code
                            let discName = try? event.getElementsByTag("small").first()?.text()
                            try? event.getElementsByTag("tag").forEach {item in try? item.remove()}
                            var comments: String?
                            if (try? event.getElementsByTag("sup").first()) != nil && noticesMap[(try? event.getElementsByTag("sup").first()!.text(trimAndNormaliseWhitespace: true)) ?? ""] != nil {
                                comments = noticesMap[(try? event.getElementsByTag("sup").first()!.text(trimAndNormaliseWhitespace: true)) ?? ""]
                                try? event.getElementsByTag("sup").first()?.remove()
                            }
                            let teacherCode: String? = !needsClarification ? try? event.text() : nil
                            
                            // Clarification record
                            var clarificationMaker: Substring? = nil
                            if ((try? event.attr(" - ")) ?? "").contains(" - ") && ((try? event.attr("title")) ?? "").split(separator: "/").count > 2 {
                                clarificationMaker = try? event.attr("title").split(separator: "/").last?.components(separatedBy: " - ").last?.split(separator: "/").last
                            }
                            
                            // Colors and names
                            let typeDesc = try? doc.getElementsByClass("\(typeIdClass ?? "") text-center").first()?.parent()
                            let codeName = try? typeDesc?.children().first()?.text()
                            let fullName = try? typeDesc?.children().last()?.text()
                            let bgColor: String? = typeIdClass != nil ? bgColors[typeIdClass!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()] : nil
                            let fgColor: String? = typeIdClass != nil ? fgColors[typeIdClass!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()] : nil
                            
                            // Duration
                            var start = timeRanges[abs(spanCounter-1)]
                            var end: TimeRange
                            if spanCounter+span-1 != timeRanges.count {
                                end = timeRanges[spanCounter+span-1]
                            } else if eventCounter == 0 {
                                start = timeRanges[2]
                                end = timeRanges[3]
                            } else {
                                start = timeRanges[spanCounter-2]
                                end = timeRanges[spanCounter-1]
                            }
                            
                            var duration = Int(end.start.timeIntervalSince1970 - start.start.timeIntervalSince1970)
                            
                            var startDate: Date?
                            var endDate: Date?
                                                        
                            if duration < 0 {
                                startDate = localDate.midnight.mergeDateAndTime(end.start)
                                endDate = localDate.midnight.mergeDateAndTime(start.start)
                                duration = Int(end.start.timeIntervalSince1970 - start.start.timeIntervalSince1970)
                            } else {
                                startDate = localDate.midnight.mergeDateAndTime(start.start)
                                endDate = localDate.midnight.mergeDateAndTime(end.start)
                            }
                            
                            /// Unique ID based on lesson note properties
                            /// NOTICE! If new properties are found later on, include them here!
                            var hasher = Hasher()
                            hasher.combine(startDate)
                            hasher.combine(endDate)
                            hasher.combine(fullName)
                            hasher.combine(discName)
                            hasher.combine(courseCode)
                            hasher.combine(teacherFullName)
                            hasher.combine(bgColor)
                            hasher.combine(fgColor)
                            let id = hasher.finalize()+Int(duration)
                            
                            // Course name not available in attendance/view
                            lessonNotes.append(
                                LessonNote(
                                    id: id, clarificationId: clarificationId, noteCodename: codeName,
                                    noteName: fullName, discName: discName,
                                    courseCode: courseCode?.toString(), courseName: nil,
                                    authorCodeName: teacherCode, authorName: teacherFullName?.toString(),
                                    additionalInfo: comments, backgroundColor: bgColor,
                                    foregroundColor: fgColor, noteStart: startDate,
                                    noteEnd: endDate, duration: duration/60, clarifiedBy: clarificationMaker?.toString(), needsClarification: needsClarification))
                            eventCounter += 1
                        }
                        spanCounter += span
                    }
                }
            }
        }
        
        return lessonNotes
    }
}
