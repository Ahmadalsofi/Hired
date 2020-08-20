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

        content = try JSONDecoder().decode(Content.self, from: data)
    }

    /// Put teardown code here.
    /// This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {
    }

    func testParsing_iOS() {
        XCTAssert(content.iOS.count == 15, "Topic count is wrong \(content.iOS.count), expected 14")
    }

    func testTopicID() {
        let topicUniqueIds = Set(content.iOS.map(\.id))
        XCTAssert(topicUniqueIds.count == content.iOS.count, "Topic ID should be unique")
    }

    func testTopicIDLength() {
        content.iOS.forEach { topic in
            XCTAssert(topic.id.count == 36, "Topic ID length is wrong \(topic.id.count), expected 36")
        }
    }

    func testTopicNameLength() {
        content.iOS.forEach { topic in
            XCTAssert(topic.topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, "Topic name is empty \(topic.topic)")
            XCTAssert(topic.topic.count >= 3, "Topic name count is less than 3 \(topic.topic)")
        }
    }

    func testTopicWithQuestion() {
        content.iOS.forEach { topic in
            XCTAssert(topic.questions.count >= 1, "Topic should have questions \(topic.questions.count)")
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
    let id: String
    let topic: String
    let questions: [Question]
}

private struct Question: Decodable {
    let id: String
    let question: String
}
