import XCTest
@testable import openwilma

class CoursesTest: XCTestCase {
    
    private let server = WilmaServer(url: "https://espoondemo.inschool.fi")
    private var session: WilmaSession? = nil
    
    override func setUp() async throws {
        session = try await OpenWilma.signIn(server, "oppilas", "oppilas")
    }
    
    func testCourses() async throws {
        do {
            let courses = try await OpenWilma.getCourses(session!, .current)
            print(courses.payload?.count)
            let coursesAdditional = try await OpenWilma.getCourses(session!, .current, skipAdditionalInformation: false)
            print(coursesAdditional.payload?.first)
            let coursesPast = try await OpenWilma.getCourses(session!, .past)
            print(coursesPast.payload?.count)
            let course = try await OpenWilma.getCourse(session!, 21128)
            let courseExams = try await OpenWilma.getCourseExams(session!, 21128)
            let courseHomework = try await OpenWilma.getCourseHomework(session!, 21128)
            print(course, courseExams, courseHomework)
            do {
                let courseStudents = try await OpenWilma.getCourseStudents(session!, 21128)
                XCTAssert(false, "Course students loaded without permission!")
            } catch let err {
                print(err)
            }
        } catch let err {
            print(err)
            throw err
        }
    }
    
}
