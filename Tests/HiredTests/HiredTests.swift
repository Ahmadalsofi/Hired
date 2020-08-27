//
//  HiredTests.swift
//  HiredTests
//
//  Created by Zeeshan Khan on 17/08/2020.
//  Copyright © 2020 Zeeshan Khan. All rights reserved.
//

import XCTest
@testable import Hired

class HiredTests: XCTestCase {

    fileprivate var content: Content!
    
    /// Put setup code here.
    /// This method is called before the invocation of each test method in the class.
    override func setUpWithError() throws {
        
        let url = Bundle.testBundle.url(forResource: "Content", withExtension: "json")
        XCTAssert(url != nil, "JSON file URL is nil")
        
        let data = try! Data(contentsOf: url!)
        XCTAssert(data.count > 0, "JSON Data is empty")

        let parsedContent = try? JSONDecoder().decode(Content.self, from: data)
        XCTAssert(parsedContent != nil, "Failed to parse")
        content = parsedContent
    }

    /// Put teardown code here.
    /// This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {}

    func testParsing_iOS() {
        XCTAssert(content.iOS.count == 15, "Topic count is wrong \(content.iOS.count), expected 15")
    }

    func testTopicUniqueName() {
        let topicUniqueNames = Set(content.iOS.map { $0.title })
        XCTAssert(topicUniqueNames.count == content.iOS.count, "Topic name should be unique \(topicUniqueNames.count)")
    }

    func testTopicNameLength() {
        content.iOS.forEach { topic in
            XCTAssert(topic.title.isEmpty == false, "Topic name is empty \(topic.topic)")
            XCTAssert(topic.title.count >= 3, "Topic name count is less than 3 \(topic.topic)")
        }
    }

    func testTopicWithQuestion() {
        content.iOS.forEach { topic in
            XCTAssert(topic.questions.count >= 1, "Topic should have questions \(topic.questions.count)")
        }
    }

    func testQuestionUnique() {
        content.iOS.forEach { topic in
            let questionsUniqueness = Set(topic.questions.map { $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) })
            XCTAssert(questionsUniqueness.count == topic.questions.count, "Questions text should be unique \(questionsUniqueness.count) expected \(topic.questions.count)")
        }
    }

    func testQuestionTextLength() {
        content.iOS.forEach { topic in
            topic.questions.forEach { question in
                let text = question.trimmingCharacters(in: .whitespacesAndNewlines)
                XCTAssert(text.isEmpty == false, "Question is empty \(question)")
                XCTAssert(text.count >= 3, "Question text count is less than 3 \(question)")
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

private struct Content: Decodable {
    let iOS: [Topic]
}

private struct Topic: Decodable {
    let topic: String
    let questions: [String]
    var title: String {
        topic.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
