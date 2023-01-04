import XCTest
@testable import openwilma

class AuthenticationTests: XCTestCase {
    
    private let server = WilmaServer(url: "https://espoondemo.inschool.fi")
    
    func testSessionId() async throws {
        let session = try await OpenWilma.getSessionId(server)
        print(session)
        XCTAssert(!session.sessionId.isEmpty)
    }
    
    func testSignInBasic() async throws {
        do {
            let wilmaSession = try await OpenWilma.signIn(server, "oppilas", "oppilas")
            print(wilmaSession)
            let roles = try await OpenWilma.getRoles(wilmaSession)
            XCTAssertEqual(roles.payload?.first {$0.type == .wilma_account}, nil, "Basic account has wilma account role")
        } catch let err {
            print(err)
            throw err
        }
    }
    
    func testSignInRole() async throws {
        do {
            let wilmaSession = try await OpenWilma.signIn(server, "ope", "ope")
            print(wilmaSession)
            let roles = try await OpenWilma.getRoles(wilmaSession)
            XCTAssertNotEqual(roles.payload?.first {$0.type == .wilma_account}, nil, "Role account missing wilma account role")
        } catch let err {
            print(err)
            throw err
        }
    }
    
    func testGetRoles() async throws {
        let wilmaSession = try await OpenWilma.signIn(server, "ope", "ope")
        let roles = try await OpenWilma.getRoles(wilmaSession)
        XCTAssert(roles.payload?.isEmpty == false)
    }
    
}
