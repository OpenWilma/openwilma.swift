//
//  URLUtils.swift
//  
//
//  Created by Ruben Mkrtumyan on 3.1.2023.
//

import Foundation
public struct URLUtils {
    static func buildUrl(_ wilmaServer: WilmaServer, _ path: String) -> String {
        return wilmaServer.url.last == "/" ? wilmaServer.url+path : "\(wilmaServer.url)/\(path)"
    }
    
    static func buildUrl(_ wilmaSession: WilmaSession, _ path: String, requireRole: Bool = true) throws -> String {
        var slug = try wilmaSession.getRole(requireRole: requireRole)?.slug ?? ""
        if !slug.isEmpty && slug.first == "/" {
            slug.removeFirst()
        }
        if !slug.isEmpty && slug.last != "/" {
            slug += "/"
        }
        return wilmaSession.wilmaServer.url.last == "/" ? wilmaSession.wilmaServer.url+slug+path : "\(wilmaSession.wilmaServer.url)/\(slug)\(path)"
    }
    
    static func buildUrl(_ wilmaSession: WilmaSession, _ role: WilmaRole, _ path: String) -> String {
        var slug = role.slug ?? ""
        if !slug.isEmpty && slug.first == "/" {
            slug.removeFirst()
        }
        if !slug.isEmpty && slug.last != "/" {
            slug += "/"
        }
        return wilmaSession.wilmaServer.url.last == "/" ? wilmaSession.wilmaServer.url+slug+path : "\(wilmaSession.wilmaServer.url)/\(slug)\(path)"
    }
}
