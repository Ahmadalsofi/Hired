#!/usr/bin/env swift
import Foundation

let fm = FileManager.default
let path = fm.currentDirectoryPath
let filePath = path + "/sample.json"
print("\(filePath)")

do {
    let content = try String(contentsOfFile: filePath, encoding: .utf8)
    if let data = content.data(using: .utf8) {
        let topics = try JSONDecoder().decode(Array<Topic>.self, from: data)
        print("Parsing done: \(topics.count)")
        let jsonObject = topics.map { $0.toAny }
        if
            let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
            let json = String(data: data, encoding: .utf8),
            let url = URL(string: "file://\(filePath)") {
            print("writing: \(url)")
            try json.write(to: url, atomically: true, encoding: .utf8)
        }
    }
} catch {
    print("Error: \(error)")
}

struct Topic: Decodable {
    let topic: String
    let id: UUID
    let questions: [Question]

    private enum CodingKeys: String, CodingKey {
        case topic
        case id
        case questions
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        topic = try values.decode(String.self, forKey: .topic)
        if let idString = try? values.decode(String.self, forKey: .id),
           let uuid = UUID(uuidString: idString) {
            id =  uuid
        } else {
            print("id is nil \(topic)")
            id = UUID()
        }

        if let list = try? values.decode(Array<Question>.self, forKey: .questions) {
            questions = list
        } else {
            questions = []
        }
    }

    var toAny: Dictionary<String, Any> {
        [
            "topic": topic,
            "id": id.uuidString,
            "questions": questions.map { $0.toAny },
        ]
    }
}

struct Question: Decodable {
    let text: String
    let id: UUID

    private enum CodingKeys: String, CodingKey {
        case text
        case id
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
        if let idString = try? values.decode(String.self, forKey: .id),
           let uuid = UUID(uuidString: idString) {
            id =  uuid
        } else {
            print("id is nil \(text)")
            id = UUID()
        }
    }

    var toAny: Dictionary<String, String> {
        [
            "text": text,
            "id": id.uuidString,
        ]
    }
}
