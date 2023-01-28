//
//  UserType.swift
//  
//
//  Created by Ruben Mkrtumyan on 10.12.2022.
//

import Foundation

/**
 Wilma Account types
  - Reported from Wilma as Int number (old API and frontend) or string value (new API)
 **/
public enum UserType: String {
    case teacher = "teacher"
    case student = "student"
    case staff = "personnel"
    case guardian = "guardian"
    case workplace_instructor = "instructor"
    case board = "board"
    /// Wilma account is the account which has roles, when you enter to the role selector in browser, that account that
    /// you're currently logged in is called Wilma Account, and when you click the user, it's a Role
    case wilma_account = "passwd"
    case training_coordinator = "trainingcoordinator"
    case training = "training"
    case applicant = "applicant"
    case applicant_guardian = "applicantguardian"
    
    public var intValue: Int {
        switch self {
        case .teacher:
            return 1
        case .student:
            return 2
        case .staff:
            return 3
        case .guardian:
            return 4
        case .workplace_instructor:
            return 5
        case .board:
            return 6
        case .wilma_account:
            return 7
        case .training_coordinator:
            return 8
        case .training:
            return 9
        case .applicant:
            return 10
        case .applicant_guardian:
            return 11
        }
    }
}

/*
  Extension makes UserType Codable for encoding&decoding purposes
 */
extension UserType: Codable {
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try? container.decode(Int.self)
        let strValue = try? container.decode(String.self)
        switch intValue {
        case 1:
            self = .teacher
        case 2:
            self = .student
        case 3:
            self = .staff
        case 4:
            self = .guardian
        case 5:
            self = .workplace_instructor
        case 6:
            self = .board
        case 7:
            self = .wilma_account
        case 8:
            self = .training_coordinator
        case 9:
            self = .training
        case 10:
            self = .applicant
        case 11:
            self = .applicant_guardian
        default:
            guard let strValue = strValue, let type = UserType(rawValue: strValue) else {
                throw CodingError.unknownValue
            }
            self = type
        }
    }
     
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
    
}
