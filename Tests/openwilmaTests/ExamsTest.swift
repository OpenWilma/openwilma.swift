import XCTest
@testable import openwilma

class ExamsTest: XCTestCase {
    private let server = WilmaServer(url: "https://espoondemo.inschool.fi")
    private var session: WilmaSession? = nil
    
    override func setUp() async throws {
        session = try await OpenWilma.signIn(server, "oppilas", "oppilas")
    }
    
    /// Network
    
    func testPastExams() async throws {
        let examsList = try await OpenWilma.getPastExams(session!, start: JSONDateUtils.finnishFormatted.date(from: "9.12.2016")!, end: JSONDateUtils.finnishFormatted.date(from: "1.6.2023")!)
        print(examsList)
    }
    
    func testUpcomingExams() async throws {
        let examsList = try await OpenWilma.getUpcomingExams(session!)
        print(examsList)
    }
    
    /// Parsing
    
    func testParsingUpcoming() throws {
        let path = Bundle.module.path(forResource: "exams_upcoming", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let exams = try WilmaExamsParser.parse(contents)
        print(exams)
    }
    
    func testParsingUpcomingWithGrades() throws {
        let path = Bundle.module.path(forResource: "exams_upcoming_graded", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let exams = try WilmaExamsParser.parse(contents)
        print(exams)
    }
    
    func testParsingPast() throws {
        let path = Bundle.module.path(forResource: "exams_past", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let exams = try WilmaExamsParser.parsePast(contents)
        print(exams)
    }
    
}
