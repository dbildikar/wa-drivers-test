//
//  Question.swift
//  WADriversTest
//
//  Washington State Drivers License Practice Test
//

import Foundation

/// Represents a single question in the driver's test
struct Question: Codable, Identifiable {
    let id: String
    let category: String
    let questionText: String
    let answerOptions: [String]
    let correctIndex: Int
    let explanation: String
    let source: String
    let difficulty: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case questionText = "question_text"
        case answerOptions = "answer_options"
        case correctIndex = "correct_index"
        case explanation
        case source
        case difficulty
    }
}

/// Represents a wrong answer with details for review
struct WrongAnswer: Identifiable {
    let id = UUID()
    let questionIndex: Int
    let question: String
    let userAnswer: String
    let correctAnswer: String
    let explanation: String
    let source: String
    let category: String
}

/// Test results after completing a test
struct TestResults {
    let score: Int
    let correctAnswers: Int
    let totalQuestions: Int
    let wrongAnswers: [WrongAnswer]
    let passed: Bool
    
    var scorePercentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }
}

/// Test configuration constants
struct TestConfig {
    static let defaultQuestionCount = 25
    static let passingScore = 80
}
