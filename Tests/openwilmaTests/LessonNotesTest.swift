import XCTest
@testable import openwilma

class LessonNotesTest: XCTestCase {
    private let server = WilmaServer(url: "https://espoondemo.inschool.fi")
    private var session: WilmaSession? = nil
    
    override func setUp() async throws {
        session = try await OpenWilma.signIn(server, "oppilas", "oppilas")
    }
    
    /// Network
    
    func testLessonNotes() async throws {
        do {
            let lessonNotes = try await OpenWilma.getLessonNotes(session!, .custom, start: DateUtils.finnishFormatted.date(from: "9.12.2016"), end: DateUtils.finnishFormatted.date(from: "3.6.2023"))
            print(lessonNotes)
        } catch let e {
            print(e)
        }
    }
    
    func testLessonNotePermissions() async throws {
        do {
            let normalCanSave = try await OpenWilma.canSaveExcuse(session!)
            XCTAssert(normalCanSave == false)
            var huoltajaSession = try await OpenWilma.signIn(server, "hilla.huoltaja@example.fi", "huoltaja")
            let roles = try await OpenWilma.getRoles(huoltajaSession)
            huoltajaSession.setRole(roles.payload?.filter {$0.type != .wilma_account}[0] ?? WilmaRole(name: "", type: .guardian, primusId: -1, slug: "/!04806"))
            let huoltajaCanSave = try await OpenWilma.canSaveExcuse(huoltajaSession)
            XCTAssert(huoltajaCanSave == true)
        } catch let e {
            print(e)
        }
    }
    
    func testLessonNoteParser() async throws {
        let path = Bundle.module.path(forResource: "lesson_notes", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let notes = try WilmaLessonNoteParser.parse(contents)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .formatted(DateUtils.standard)
        print(String(data: try encoder.encode(notes), encoding: .utf8)!)
        XCTAssert(notes.first?.noteCodename == "03")
        XCTAssert(notes.first?.noteName == "Muu kouluntoiminta /ei tunnilla")
        XCTAssert(notes.first?.courseCode == "MU2")
        XCTAssert(notes.first?.authorCodeName == "BLA")
        XCTAssert(notes.first?.authorName == "Bianca Blackburn")
        XCTAssert(notes.first?.backgroundColor == "#80ff80")
        XCTAssert(notes.first?.foregroundColor == "#000000" || notes.first?.foregroundColor == "#000")
        XCTAssert(notes.first?.noteStart == Date(timeIntervalSince1970: 1519714800))
        XCTAssert(notes.first?.noteEnd == Date(timeIntervalSince1970: 1519717500))
        XCTAssert(notes.first?.duration == 45)
        XCTAssert(notes.first?.clarifiedBy == nil)
        XCTAssert(notes.count == 14)
    }
    
    func testLessonNotesEmpty() throws {
        let path = Bundle.module.path(forResource: "lesson_notes_empty", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let lessonNotes = try WilmaLessonNoteParser.parse(contents)
        XCTAssert(lessonNotes.isEmpty)
    }
    
    func testParseClarificationInfo() throws {
        let path = Bundle.module.path(forResource: "lesson_notes_clarify", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let lessonNotes = try WilmaLessonNoteParser.parse(contents)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .formatted(DateUtils.standard)
        print(String(data: try encoder.encode(lessonNotes), encoding: .utf8)!)
    }
    
}
