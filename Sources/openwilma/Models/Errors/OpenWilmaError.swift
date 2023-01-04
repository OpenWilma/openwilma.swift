//
//  OpenWilmaError.swift
//  
//
//  Created by Ruben Mkrtumyan on 24.12.2022.
//

import Foundation

public protocol OpenWilmaErrorProtocol: LocalizedError {
    var title: String? { get }
    var code: Int { get }
    var errorType: OpenWilmaErrorType { get }
}


public struct OpenWilmaError: OpenWilmaErrorProtocol {
    

    public var title: String?
    public var code: Int
    public var errorDescription: String? { return _description }
    public var failureReason: String? { return _description }
    public var errorType: OpenWilmaErrorType
    private var _description: String

    init(title: String?, errorType: OpenWilmaErrorType, description: String? = nil) {
        self.title = title ?? "Error"
        self._description = description ?? "No description provided"
        self.errorType = errorType
        self.code = errorType.rawValue
    }
}

