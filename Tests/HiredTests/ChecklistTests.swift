//
//  ChecklistTests.swift
//  HiredTests
//
//  Created by Zeeshan Khan on 25/08/2020.
//  Copyright © 2020 Zeeshan Khan. All rights reserved.
//

import XCTest
@testable import Hired

class ChecklistTests: XCTestCase {

    fileprivate var content: Content!
    
    /// Put setup code here.
    /// This method is called before the invocation of each test method in the class.
    override func setUpWithError() throws {
        
        let url = Bundle.testBundle.url(forResource: "Checklist", withExtension: "json")
        XCTAssert(url != nil, "JSON file URL is nil")
        
        let data = try! Data(contentsOf: url!)
        XCTAssert(data.count > 0, "JSON Data is empty")

        content = try JSONDecoder().decode(Content.self, from: data)
    }

    /// Put teardown code here.
    /// This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {}

    func testParsing_iOS() {
        XCTAssert(content.iOS.count == 3, "Checklist count is wrong \(content.iOS.count), expected 3")
    }

    func testNameLength() {
        content.iOS.forEach { checklist in
            XCTAssert(checklist.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, "Checklist title is empty \(checklist.title)")
            XCTAssert(checklist.title.count >= 3, "Checklist title count is less than 3 \(checklist.title)")
        }
    }

    func testListCount() {
        content.iOS.forEach { checklist in
            XCTAssert(checklist.list.count >= 1, "Checklist should have items \(checklist.list.count)")
        }
    }
    
    func testItemTextLength() {
        content.iOS.forEach { checklist in
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

private struct Content: Decodable {
    let iOS: [Checklist]
}

private struct Checklist: Decodable {
    let title: String
    let list: [String]
}
