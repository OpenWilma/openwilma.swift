//
//  WilmaAnnouncementsParser.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation
import SwiftSoup

public struct WilmaAnnouncementsParser {
    
    private static let creatorRegex = try! NSRegularExpression(pattern: #"\((.*?)\)"#, options: [])
    static let dateFormat: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Helsinki")
        return dateFormatter
    }()
    
    static func parseAnnouncements(_ htmlContent: String) throws -> [Announcement] {
        let doc: Document = try SwiftSoup.parse(htmlContent)
        let announcementItems = try doc.getElementsByClass("left").first()?.getElementsByClass("panel-body").first()?.children()
        var announcements: [Announcement] = []
        
        if let announcementItems = announcementItems {
            var currentDate: Date? = nil
            
            for element in announcementItems {
                if element.tagNameNormal() == "h2" {
                    // Title
                    if (try? element.text())?.split(separator: ".").last?.isEmpty == true {
                        // autofill current year
                        currentDate = dateFormat.date(from: "\(try element.text().trimmingCharacters(in: .whitespacesAndNewlines))\(Calendar.current.component(.year, from: Date()))")
                    } else if (try? element.text()) == "tänään" {
                        currentDate = Date().midnight
                    } else if (try? element.text()) == "eilen" {
                        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!.midnight
                    } else {
                        currentDate = dateFormat.date(from: try element.text().trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                } else if element.tagNameNormal() == "div" && element.hasClass("well") && currentDate != nil {
                    let title = try element.getElementsByTag("h3").first()!.text()
                    let description = try? element.getElementsByClass("sub-text").first()?.text()
                    // If news id is not present, user is unable to view its full content.
                    let newsId = Int((try? element.getElementsByTag("a").first()?.attr("href"))?.split(separator: "/").last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? -1
                    let linkContainer = try? element.getElementsByClass("horizontal-link-container small").first()
                    let creatorElement = try? linkContainer?.getElementsByAttribute("title").first()
                    let creatorCode: String? = try? creatorElement?.text()
                    var creatorName: String? = try? creatorElement?.attr("title")
                    
                    if creatorName == nil, let creatorValue = try? linkContainer?.text(), let backupMethodName = creatorRegex.firstMatch(in: creatorValue, range: NSRange(creatorValue.startIndex..<creatorValue.endIndex, in: creatorValue)).map({String(creatorValue[Range($0.range, in: creatorValue)!])}) {
                      creatorName = String(backupMethodName)
                    }
                    
                    var creatorId: Int? = nil
                    var creatorType: UserType? = nil
                    let important = ((try? element.getElementsByClass("vismaicon-info").isEmpty()) == false)
                    let permanent = ((try? element.getElementsByClass("vismaicon-locked").isEmpty()) == false)
                    
                    if creatorElement?.tagNameNormal() == "a" {
                        // Profile link
                        creatorType = UserType(rawValue: String((try? creatorElement?.attr("href").components(separatedBy: "profiles/").last?.components(separatedBy: "/").first?.dropLast(1)) ?? ""))
                        creatorId = Int((try? creatorElement?.attr("href").split(separator: "/").last) ?? "")
                    }
                    announcements.append(Announcement(id: newsId, subject: title, description: description, contentHTML: nil, authorName: creatorName, authorCode: creatorCode, authorId: creatorId, authorType: creatorType, timestamp: currentDate, important: important, permanent: permanent))
                }
            }
        }
        
        return announcements
    }
    
    static func parseAnnouncement(_ htmlDocument: String) throws -> Announcement? {
        let doc: Document = try SwiftSoup.parse(htmlDocument)
        guard let card = try? doc.getElementsByClass("panel-body").first(), let stringNewsId = try? doc.getElementsByAttributeValue("target", "preview").first()?.attr("href").split(separator: "/").last?.trimmingCharacters(in: .whitespacesAndNewlines), let newsId = Int(stringNewsId) else {
            return nil
        }
        let newsContent = try? card.getElementById("news-content")?.html()
        let title = try card.getElementsByTag("h2").first()!.text()
        let createDateElement = try? card.getElementsByClass("small semi-bold").first()
        
        var timestamp: Date? {
            if let createDateElement = createDateElement {
                if (try? createDateElement.text())?.split(separator: ".").last?.isEmpty == true {
                    // autofill current year
                    return dateFormat.date(from: "\(try! createDateElement.text().trimmingCharacters(in: .whitespacesAndNewlines))\(Calendar.current.component(.year, from: Date()))")
                } else {
                    return dateFormat.date(from: try! createDateElement.text().trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
            return nil
        }
        
        var description: String? {
            if (try? card.getElementById("news-content")?.previousElementSibling()?.tagNameNormal()) == "p" {
                return try? card.getElementById("news-content")?.previousElementSibling()?.text()
            }
            return nil
        }
        
        let creatorBox = try? card.getElementsByClass("horizontal-link-container").first()
        let creatorValue: String = (try? creatorBox?.child(1).text()) ?? ""
        let regexResult = creatorRegex.firstMatch(in: creatorValue, range: NSRange(creatorValue.startIndex..<creatorValue.endIndex, in: creatorValue)).map({String(creatorValue[Range($0.range, in: creatorValue)!])})
        let creatorName: String? = try? regexResult?.replacingRegex(matching: "[()]", with: "") ?? creatorValue.replacingRegex(matching: "[()]", with: "")
        let creatorCode = try? creatorBox?.child(1).text().split(separator: "(").first?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var creatorId: Int? = nil
        var creatorType: UserType? = nil
        
        if creatorBox?.child(1).tagNameNormal() == "a" {
            // Profile link
            creatorType = UserType(rawValue: String((try? creatorBox?.child(1).attr("href").components(separatedBy: "profiles/").last?.components(separatedBy: "/").first?.dropLast(1)) ?? ""))
            creatorId = Int((try? creatorBox?.child(1).attr("href").split(separator: "/").last) ?? "")
        }
        return Announcement(id: newsId, subject: title, description: description, contentHTML: newsContent, authorName: creatorName, authorCode: creatorCode, authorId: creatorId, authorType: creatorType, timestamp: timestamp)
    }
}
