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
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .formatted(DateUtils.standard)
        print(String(data: try decoder.encode(scheduleRange), encoding: .utf8)!)
    }
    
    func testWeekSplitter() {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .formatted(DateUtils.standard)
        print(String(data: try! decoder.encode(DateUtils.splitWeeksFromRange(Date(), Date().addDays(days: 12)!)), encoding: .utf8)!)
        print(String(data: try! decoder.encode([Date(), Date().addDays(days: 12)!]), encoding: .utf8)!)
    }
    
}
