import XCTest
@testable import openwilma

class AnnouncementsTest: XCTestCase {
    private let server = WilmaServer(url: "https://espoondemo.inschool.fi")
    private var session: WilmaSession? = nil
    
    override func setUp() async throws {
        session = try await OpenWilma.signIn(server, "ope", "ope")
        let roles = try await OpenWilma.getRoles(session!)
        session?.setRole((roles.payload?.first {$0.type != .wilma_account})!)
    }
    
    /// Network
    
    func testLoadingList() async throws {
        let announcementsList = try await OpenWilma.getAnnouncements(session!)
        print(announcementsList)
    }
    
    func testLoadingContent() async throws {
        let announcementsList = try await OpenWilma.getAnnouncement(session!, 21)
        print(announcementsList)
    }
    
    /// Parsing
    
    func testParsingList() throws {
        let path = Bundle.module.path(forResource: "announcements", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let announcementsList = try WilmaAnnouncementsParser.parseAnnouncements(contents)
        print(announcementsList)
        XCTAssert(announcementsList.count == 12)
    }
    
    func testParsingContent() throws {
        let path = Bundle.module.path(forResource: "announcement", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let announcement = try WilmaAnnouncementsParser.parseAnnouncement(contents)
        print(announcement)
        XCTAssert(announcement?.id == 3262)
        XCTAssert(announcement?.subject == "Wilman uusi osoite on tuusula.inschool.fi")
        XCTAssert(announcement?.description == "Wilman uusi osoite on tuusula.inschool.fi")
        XCTAssert(announcement?.authorName == "Ylläpitäjä")
        XCTAssert(announcement?.authorCode == "Ylläpitäjä")
    }
    
    func testParsingContentNoDesc() throws {
        let path = Bundle.module.path(forResource: "announcement_nodesc", ofType: "data")
        let contents = try! String(contentsOfFile: path!)
        
        let announcement = try WilmaAnnouncementsParser.parseAnnouncement(contents)
        print(announcement)
        XCTAssert(announcement?.id == 3508)
        XCTAssert(announcement?.subject == "Hei nuori! Nappaa käyttöösi Normaali.fi -huolitesti, videot sekä chat")
        XCTAssert(announcement?.description == nil)
        XCTAssert(announcement?.authorName == "Arttu Tirkkonen")
        XCTAssert(announcement?.authorCode == "TiA")
    }
    
}
