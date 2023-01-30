//
//  WilmaHTTPClient.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation
import Alamofire

struct WilmaRedirectHandler: RedirectHandler {
    func task(_ task: URLSessionTask, willBeRedirectedTo request: URLRequest, for response: HTTPURLResponse, completion: @escaping (URLRequest?) -> Void) {
        if ((response.url?.query?.contains("invalidsession")) == true) {
            var newReq = request
            newReq.url = URL(string: (request.url?.baseURL?.formatted() ?? "")+"/messages/index_json", relativeTo: request.url)
            completion(newReq)
            return
        }
        completion(request)
    }
}

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
        session = Session(configuration: configuration, redirectHandler: WilmaRedirectHandler())
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
