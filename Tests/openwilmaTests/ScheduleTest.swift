import XCTest
@testable import openwilma

class ScheduleTest: XCTestCase {
    private let server = WilmaServer(url: "https://espoondemo.inschool.fi")
    private var session: WilmaSession? = nil
    
    override func setUp() async throws {
        session = try await OpenWilma.signIn(server, "oppilas", "oppilas")
    }
    
    /// Network
    
    func testSchedule() async throws {
        do {
            let schedule = try await OpenWilma.getSchedule(session!)
            print(schedule)
        } catch let e {
            print(e)
        }
    }
    
    func testScheduleRange() async throws {
        let scheduleRange = try await OpenWilma.getScheduleRange(session!, Date(), Date().addDays(days: 12)!)
        print(scheduleRange)
    }
    
}
