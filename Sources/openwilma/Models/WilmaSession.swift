//
//  WilmaSession.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.12.2022.
//

import Foundation

public struct WilmaSession: Codable, Hashable {
    public var wilmaServer: WilmaServer = WilmaServer(url: "")
    public var sessionId: String = ""
    private var accountInfo: WilmaAccountInfo? = nil
    private var role: WilmaRole? = nil
    
    public init(wilmaServer: WilmaServer, sessionId: String, accountInfo: WilmaAccountInfo? = nil, role: WilmaRole? = nil) {
        self.wilmaServer = wilmaServer
        self.sessionId = sessionId
        self.accountInfo = accountInfo
        self.role = role
    }
    
    public func getRole(requireRole: Bool = true) throws -> WilmaRole? {
        if ((role == nil || role?.type == UserType.wilma_account) && accountInfo != nil && requireRole && !OpenWilma.disableRoleRequirement) {
            throw OpenWilmaError(title: "Valid role is required for this account", errorType: .RoleRequired, description: "Method calling 'getRole' requires session to have a valid role.")
        }
        return role
    }
    
    public mutating func setRole(_ role: WilmaRole) {
        self.role = role
    }
    
    public func getAccountInfo() -> WilmaAccountInfo? {
        return accountInfo
    }
}
