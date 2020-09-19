import XCTest
@testable import Hired

class iOSHiredTests: XCTestCase {

    fileprivate var content: [Topic]!

    /// Put setup code here.
    /// This method is called before the invocation of each test method in the class.
    override func setUpWithError() throws {

        let url = Bundle.testBundle.url(forResource: "iOS", withExtension: "json")
        XCTAssert(url != nil, "JSON file URL is nil")

        let data = try! Data(contentsOf: url!)
        XCTAssert(data.count > 0, "JSON Data is empty")

        let parsedContent = try? JSONDecoder().decode(Array<Topic>.self, from: data)
        XCTAssert(parsedContent != nil, "Failed to parse")
        content = parsedContent
    }

    /// Put teardown code here.
    /// This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {}

    func testParsing() {
        XCTAssert(content.count == 15, "Topic count is wrong \(content.count), expected 14")
    }

    func testTopicID() {
        let topicUniqueIds = Set(content.map(\.idText))
        XCTAssert(topicUniqueIds.count == content.count, "Topic ID should be unique")
    }

    func testTopicIDLength() {
        content.forEach { topic in
            XCTAssert(topic.idText.count == 36, "Topic ID length is wrong \(topic.idText.count), expected 36")
        }
    }

    func testTopicUniqueName() {
        let topicUniqueNames = Set(content.map { $0.title })
        XCTAssert(topicUniqueNames.count == content.count, "Topic name should be unique \(topicUniqueNames.count)")
    }

    func testTopicNameLength() {
        content.forEach { topic in
            XCTAssert(topic.title.isEmpty == false, "Topic name is empty \(topic.title)")
            XCTAssert(topic.title.count >= 3, "Topic name count is less than 3 \(topic.title)")
        }
    }

    func testTopicWithQuestion() {
        content.forEach { topic in
            XCTAssert(topic.questions.count >= 1, "Topic should have questions \(topic.questions.count)")
        }
    }

    func testQuestionIDUniqueness() {
        content.forEach { topic in
            let questionsUniqueIds = Set(topic.questions.map(\.idText))
            XCTAssert(questionsUniqueIds.count == topic.questions.count, "Question ID should be unique")
        }
    }

    func testQuestionIDLength() {
        content.forEach { topic in
            topic.questions.forEach { question in
                XCTAssert(question.idText.count == 36, "Question ID length is wrong \(question.idText.count), expected 36")
            }
        }
    }

    func testQuestionUnique() {
        /// Single topic questions uniqueness
        content.forEach { topic in
            let questionsUniqueness = Set(topic.questions.map { $0.text })
            XCTAssert(questionsUniqueness.count == topic.questions.count, "Questions text should be unique \(questionsUniqueness.count) expected \(topic.questions.count)")
        }

        /// All topics questions uniqueness
        /// Lets duplicate questions in different topics
//        let allQuestionsList = content.reduce([]) { $0 + $1.questions.map { $0.text } }
//        let allQuestionsSet = Set.init(allQuestionsList)
//        XCTAssert(allQuestionsList.count == allQuestionsSet.count, "Questions text should be unique \(allQuestionsList.count) expected \(allQuestionsSet.count)")
    }

    func testQuestionTextLength() {
        content.forEach { topic in
            topic.questions.forEach { question in
                XCTAssert(question.text.isEmpty == false, "Question is empty \(question.question)")
                XCTAssert(question.question.count >= 3, "Question text count is less than 3 \(question.question)")
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

private struct Topic: Decodable {
    let id: String
    let topic: String
    let questions: [Question]
    var idText: String {
        id.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var title: String {
        topic.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct Question: Decodable {
    let id: String
    let question: String
    var idText: String {
        id.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var text: String {
        question.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
