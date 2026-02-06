//
//  QuestionDatabase.swift
//  WADriversTest
//
//  Manages loading and accessing questions from the bundled JSON file
//

import Foundation

/// Singleton class that manages the question database
class QuestionDatabase {
    static let shared = QuestionDatabase()
    
    private var questions: [Question] = []
    private var isLoaded = false
    
    private init() {}
    
    /// Load questions from the bundled JSON file
    func loadQuestions() throws {
        guard !isLoaded else { return }
        
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            throw QuestionDatabaseError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            questions = try decoder.decode([Question].self, from: data)
            isLoaded = true
            print("Successfully loaded \(questions.count) questions")
        } catch {
            print("Error loading questions: \(error)")
            throw QuestionDatabaseError.parsingError(error)
        }
    }
    
    /// Get all questions
    var allQuestions: [Question] {
        return questions
    }
    
    /// Get total number of questions
    var count: Int {
        return questions.count
    }
    
    /// Get a random subset of questions
    /// - Parameter count: Number of questions to return
    /// - Returns: Array of randomly selected questions
    func getRandomQuestions(count: Int) -> [Question] {
        guard isLoaded else {
            print("Warning: Questions not loaded yet")
            return []
        }
        
        let shuffled = questions.shuffled()
        return Array(shuffled.prefix(min(count, questions.count)))
    }
    
    /// Get questions by category
    /// - Parameter category: The category to filter by
    /// - Returns: Array of questions in the specified category
    func getQuestions(byCategory category: String) -> [Question] {
        return questions.filter { $0.category == category }
    }
    
    /// Get all unique categories
    var categories: [String] {
        return Array(Set(questions.map { $0.category })).sorted()
    }
}

/// Errors that can occur when loading questions
enum QuestionDatabaseError: Error, LocalizedError {
    case fileNotFound
    case parsingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Question file not found in bundle"
        case .parsingError(let error):
            return "Failed to parse questions: \(error.localizedDescription)"
        }
    }
}
