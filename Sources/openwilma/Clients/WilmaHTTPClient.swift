//
//  WilmaHTTPClient.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation
import Alamofire

public struct WilmaHTTPClient {
    
    static let shared = WilmaHTTPClient()
    
    let configuration = URLSessionConfiguration.af.default
    
    private var sessionNoRedir: Session
    private var session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = [.defaultAcceptEncoding, .defaultAcceptLanguage, .userAgent("OpenWilma/\(OpenWilma.versionName) (swift)")]
        configuration.httpCookieStorage = nil
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        sessionNoRedir = Session(configuration: configuration, redirectHandler: Redirector(behavior: .doNotFollow))
        session = Session(configuration: configuration)
    }
    
    private func wilmaHeaders(_ wilmaSession: WilmaSession? = nil) -> HTTPHeaders? {
        if let wilmaSession = wilmaSession {
            var headers = HTTPHeaders()
            headers.add(HTTPHeader(name: "Cookie", value: wilmaSession.sessionId))
            return headers
        }
        return nil
    }
    
    public func getRequest(_ url: String, wilmaSession: WilmaSession? = nil, noRedirect: Bool = false) -> DataRequest {
        return (noRedirect ? sessionNoRedir : session).request(url, headers: wilmaHeaders(wilmaSession))
    }
    
    public func postRequest(_ urlRequest: URLRequest, wilmaSession: WilmaSession? = nil, noRedirect: Bool = false) -> DataRequest {
        var urlReq = urlRequest
        urlReq.headers = wilmaHeaders(wilmaSession) ?? urlReq.headers
        return (noRedirect ? sessionNoRedir : session).request(urlReq)
    }
    
}
