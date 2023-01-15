//
//  Profile.swift.swift
//  
//
//  Created by Ruben Mkrtumyan on 4.1.2023.
//

import Foundation

public extension OpenWilma {
    
    static func getUserAccount(_ wilmaSession: WilmaSession) async throws -> WilmaAPIResponse<WilmaAccountInfo>  {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateUtils.nonStandard)
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession.wilmaServer, "api/v1/accounts/me"), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<WilmaAccountInfo>.self, decoder: decoder).value
        if let error = response.error {
            throw error
        }
        return response
    }
    
    static func getRoles(_ wilmaSession: WilmaSession, roleRequired: Bool = false) async throws -> WilmaAPIResponse<[WilmaRole]>  {
        let response = try await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, "api/v1/accounts/me/roles", requireRole: roleRequired), wilmaSession: wilmaSession).serializingDecodable(WilmaAPIResponse<[WilmaRole]>.self).value
        
        if let error = response.error {
            throw error
        }
        
        var roles = response.payload ?? []
        for role in roles {
            roles[roles.firstIndex(of: role)!].profilePicture = try? await getRoleProfilePicture(wilmaSession, role)
        }
        
        return WilmaAPIResponse(statusCode: response.statusCode, payload: roles)
    }
    
    static func getActiveRole(_ wilmaSession: WilmaSession, roleRequired: Bool = false) async throws -> WilmaRole? {
        let roles = try await self.getRoles(wilmaSession, roleRequired: roleRequired)
        if let role = try? wilmaSession.getRole(requireRole: roleRequired) {
            return roles.payload?.first {$0.primusId == role.primusId && $0.type == role.type}
        } else if let accountInfo = wilmaSession.getAccountInfo() {
            return roles.payload?.first {$0.primusId == accountInfo.primusId && $0.type == .wilma_account}
        }
        return roles.payload?.first {$0.type == .wilma_account} ?? roles.payload?.first {$0.type != .wilma_account}
    }
    
    static func getRoleProfilePicture(_ wilmaSession: WilmaSession, _ role: WilmaRole) async throws -> String? {
        let response = await WilmaHTTPClient.shared.getRequest(URLUtils.buildUrl(wilmaSession, role, "profiles/photo"), wilmaSession: wilmaSession).serializingData().response
        if response.response?.statusCode == 200, let data = response.data {
            return data.base64EncodedString()
        }
        return nil
    }
    
}
