//
//  Authentication.swift
//  
//
//  Created by Ruben Mkrtumyan on 3.1.2023.
//

import Foundation
import Alamofire

public extension OpenWilma {
    static func getSessionId(_ wilmaServer: WilmaServer, skipVersionValidation: Bool = false) async throws -> SessionResponse  {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaServer, "index_json")).serializingDecodable(SessionResponse.self).value
        if (response.apiVersion < OpenWilma.minimumSupportedWilmaVersion && !skipVersionValidation) {
            throw OpenWilmaError(title: "Wilma version \(response.apiVersion) is not supported. Minimum supported version is \(OpenWilma.minimumSupportedWilmaVersion)", errorType: .UnsupportedServer)
        }
        return response
    }
    
    static func signIn(_ wilmaServer: WilmaServer, _ username: String, _ password: String,  skipVersionValidation: Bool = false) async throws -> WilmaSession {
        let sessionId = try await OpenWilma.getSessionId(wilmaServer, skipVersionValidation: skipVersionValidation)
        var urlRequest = URLRequest(url: URL(string: URLUtils.buildUrl(wilmaServer, "login"))!)
        urlRequest.method = .post
        let parameters = [
            "Login": username,
            "Password": password,
            "SESSIONID": sessionId.sessionId,
            "CompleteJson": "",
            "format": "json"
        ]
        urlRequest.httpBody = try URLEncodedFormEncoder().encode(parameters)
        
        let response = await WilmaHTTPClient.shared.postRequest(urlRequest, noRedirect: true).serializingString().response
        
        // Check if Wilma error response in JSON format is present and throw an exception
        if let content = response.data, JSONSerialization.isValidJSONObject(content), let errorContent = try? JSONDecoder().decode(JSONErrorResponseModel.self, from: content), let wilmaError = errorContent.error {
            throw wilmaError
        }
        
        guard let headers = response.response?.headers, let location = headers.value(for: "Location") else {
            throw OpenWilmaError(title: "No redirect header", errorType: .InvalidContent)
        }
        
        let redirectUrl = URL(string: location)!
        
        var sessionCookie: String? = nil
        
        if redirectUrl.path.first == "/" || redirectUrl.path.starts(with: "/!") {
            var query = ""
            if #available(iOS 16.0, *) {
                query = redirectUrl.query(percentEncoded: false) ?? ""
            } else {
                query = redirectUrl.query ?? ""
            }
            
            // Check for failed login
            if query.contains("loginfailed") {
                throw ErrorDefinitions.CredentialsError
            }
            
            
            // Check for session cookies
            if query.contains("checkcookie") {
                if let header = headers.value(for: "Set-Cookie"), let wilmaSid = header.split(separator: ",").first(where: {$0.contains("Wilma2SID=")}) {
                    sessionCookie = String(wilmaSid)
                } else {
                    throw OpenWilmaError(title: "Session cookie headers missing or invalid", errorType: .InvalidContent)
                }
            }
        } else if redirectUrl.path == "/mfa" {
            throw ErrorDefinitions.MFAError
        } else {
            throw OpenWilmaError(title: "Unrecognized redirect: \(redirectUrl.path)", errorType: .InvalidContent)
        }
        
        guard let sessionCookie = sessionCookie else {
            throw OpenWilmaError(title: "Sign In failed", errorType: .Unknown)
        }
        
        let tempSession = WilmaSession(wilmaServer: wilmaServer, sessionId: sessionCookie)
        
        let userInfo = try await self.getUserAccount(tempSession)
        
        if userInfo.payload == nil {
            let roles = try await self.getRoles(tempSession)
            if let roles = roles.payload, !roles.isEmpty {
                return WilmaSession(wilmaServer: wilmaServer, sessionId: sessionCookie, accountInfo: userInfo.payload, role: roles.first)
            }
            throw OpenWilmaError(title: "Could not find account role", errorType: .InvalidContent)
        }
        if userInfo.payload?.mfaEnabled == true {
            throw ErrorDefinitions.MFAError
        }
        return WilmaSession(wilmaServer: wilmaServer, sessionId: sessionCookie, accountInfo: userInfo.payload)
    }
}
