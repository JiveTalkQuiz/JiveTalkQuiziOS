//
//  Quiz.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/15.
//  Copyright © 2020 sihon321. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quiz = try Quiz(json)

import Foundation

// MARK: - Quiz
struct Quiz: Codable {
    let quiz: [QuizElement]
}

// MARK: Quiz convenience initializers and mutators

extension Quiz {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Quiz.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        quiz: [QuizElement]? = nil
    ) -> Quiz {
        return Quiz(
            quiz: quiz ?? self.quiz
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - QuizElement
struct QuizElement: Codable {
    let id: Int
    let word: String
    let selection: [Selection]
}

// MARK: QuizElement convenience initializers and mutators

extension QuizElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(QuizElement.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        title: String? = nil,
        word: String? = nil,
        selection: [Selection]? = nil
    ) -> QuizElement {
        return QuizElement(
            id: id ?? self.id,
            word: word ?? self.word,
            selection: selection ?? self.selection
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Selection
struct Selection: Codable {
    let statement: String
    let correct: Bool
}

// MARK: Selection convenience initializers and mutators

extension Selection {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Selection.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        statement: String? = nil,
        correct: Bool? = nil
    ) -> Selection {
        return Selection(
            statement: statement ?? self.statement,
            correct: correct ?? self.correct
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
