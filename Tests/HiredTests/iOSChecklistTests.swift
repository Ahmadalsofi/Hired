import XCTest
@testable import Hired

class iOSChecklistTests: XCTestCase {

    fileprivate var content: [Checklist]!
    
    /// Put setup code here.
    /// This method is called before the invocation of each test method in the class.
    override func setUpWithError() throws {
        
        let url = Bundle.testBundle.url(forResource: "iOS_Checklist", withExtension: "json")
        XCTAssert(url != nil, "JSON file URL is nil")
        
        let data = try! Data(contentsOf: url!)
        XCTAssert(data.count > 0, "JSON Data is empty")

        let parsedContent = try? JSONDecoder().decode(Array<Checklist>.self, from: data)
        XCTAssert(parsedContent != nil, "Failed to parse")
        content = parsedContent
    }

    /// Put teardown code here.
    /// This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {}

    func testParsing_iOS() {
        XCTAssert(content.count == 3, "Checklist count is wrong \(content.count), expected 3")
    }

    func testNameLength() {
        content.forEach { checklist in
            XCTAssert(checklist.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, "Checklist title is empty \(checklist.title)")
            XCTAssert(checklist.title.count >= 3, "Checklist title count is less than 3 \(checklist.title)")
        }
    }

    func testListCount() {
        content.forEach { checklist in
            XCTAssert(checklist.list.count >= 1, "Checklist should have items \(checklist.list.count)")
        }
    }
    
    func testItemTextLength() {
        content.forEach { checklist in
            checklist.list.forEach { item in
                XCTAssert(item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, "Question is empty \(item)")
                XCTAssert(item.count >= 3, "item text count is less than 3 \(item)")
            }
        }
    }
}

private extension Bundle {
    private final class BundleToken {}
    static let testBundle: Bundle = {
        let baseBundle = Bundle(for: BundleToken.self)
        return Bundle(path: baseBundle.bundlePath + "/../Hired_Hired.bundle")!
    }()
}

private struct Checklist: Decodable {
    let title: String
    let list: [String]
}
