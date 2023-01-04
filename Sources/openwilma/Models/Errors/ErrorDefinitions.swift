//
//  ErrorDefinitions.swift
//  
//
//  Created by Ruben Mkrtumyan on 27.12.2022.
//

import Foundation

/// All error types defined for usage
public struct ErrorDefinitions {
    public static let ExpiredSessionError = OpenWilmaError(title: "Wilma session expired", errorType: .ExpiredSession)
    public static let MFAError = OpenWilmaError(title: "MFA is not yet supported in OpenWilma.Swift", errorType: .MFARequired)
    public static let CredentialsError = OpenWilmaError(title: "Invalid credentials for login", errorType: .LoginError)
}
