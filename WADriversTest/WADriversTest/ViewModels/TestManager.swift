//
//  TestManager.swift
//  WADriversTest
//
//  ViewModel that manages the state of a practice test
//

import Foundation
import SwiftUI

/// Observable class that manages the test state and logic
@MainActor
class TestManager: ObservableObject {
    // MARK: - Published Properties
    
    @Published var currentQuestions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var userAnswers: [Int?] = []
    @Published var testStarted: Bool = false
    @Published var testCompleted: Bool = false
    @Published var testResults: TestResults?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    
    var currentQuestion: Question? {
        guard testStarted,
              currentQuestionIndex >= 0,
              currentQuestionIndex < currentQuestions.count else {
            return nil
        }
        return currentQuestions[currentQuestionIndex]
    }
    
    var currentQuestionNumber: Int {
        return currentQuestionIndex + 1
    }
    
    var totalQuestions: Int {
        return currentQuestions.count
    }
    
    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentQuestionNumber) / Double(totalQuestions)
    }
    
    var canGoToNext: Bool {
        return userAnswers.indices.contains(currentQuestionIndex) &&
               userAnswers[currentQuestionIndex] != nil
    }
    
    var canGoToPrevious: Bool {
        return currentQuestionIndex > 0
    }
    
    var canSubmit: Bool {
        return currentQuestionIndex == currentQuestions.count - 1 &&
               userAnswers.indices.contains(currentQuestionIndex) &&
               userAnswers[currentQuestionIndex] != nil
    }
    
    var isLastQuestion: Bool {
        return currentQuestionIndex == currentQuestions.count - 1
    }
    
    var selectedAnswer: Int? {
        guard userAnswers.indices.contains(currentQuestionIndex) else { return nil }
        return userAnswers[currentQuestionIndex]
    }
    
    // MARK: - Methods
    
    /// Initialize the test manager and load questions
    func loadQuestions() {
        isLoading = true
        errorMessage = nil
        
        do {
            try QuestionDatabase.shared.loadQuestions()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    /// Start a new test with the specified number of questions
    func startTest(questionCount: Int = TestConfig.defaultQuestionCount) {
        // Get random questions
        currentQuestions = QuestionDatabase.shared.getRandomQuestions(count: questionCount)
        
        guard !currentQuestions.isEmpty else {
            errorMessage = "No questions available"
            return
        }
        
        // Initialize test state
        currentQuestionIndex = 0
        userAnswers = Array(repeating: nil, count: currentQuestions.count)
        testStarted = true
        testCompleted = false
        testResults = nil
        errorMessage = nil
        
        print("Started test with \(currentQuestions.count) questions")
    }
    
    /// Record an answer for the current question
    func answerQuestion(answerIndex: Int) {
        guard testStarted,
              currentQuestionIndex < currentQuestions.count,
              answerIndex >= 0,
              answerIndex < (currentQuestion?.answerOptions.count ?? 0) else {
            return
        }
        
        userAnswers[currentQuestionIndex] = answerIndex
        print("Question \(currentQuestionNumber) answered: \(answerIndex)")
    }
    
    /// Move to the next question
    func nextQuestion() -> Bool {
        if currentQuestionIndex < currentQuestions.count - 1 {
            currentQuestionIndex += 1
            print("Moved to question \(currentQuestionNumber)")
            return true
        }
        return false
    }
    
    /// Move to the previous question
    func previousQuestion() -> Bool {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            print("Moved to question \(currentQuestionNumber)")
            return true
        }
        return false
    }
    
    /// Submit the test and calculate results
    func submitTest() {
        guard testStarted, !testCompleted else { return }
        
        print("Submitting test...")
        
        var correctCount = 0
        var wrongAnswers: [WrongAnswer] = []
        
        for (index, question) in currentQuestions.enumerated() {
            let userAnswer = userAnswers[index]
            
            if userAnswer == question.correctIndex {
                correctCount += 1
            } else {
                let wrongAnswer = WrongAnswer(
                    questionIndex: index + 1,
                    question: question.questionText,
                    userAnswer: userAnswer != nil ? question.answerOptions[userAnswer!] : "No answer",
                    correctAnswer: question.answerOptions[question.correctIndex],
                    explanation: question.explanation,
                    source: question.source,
                    category: question.category
                )
                wrongAnswers.append(wrongAnswer)
            }
        }
        
        let score = currentQuestions.isEmpty ? 0 : Int((Double(correctCount) / Double(currentQuestions.count)) * 100)
        let passed = score >= TestConfig.passingScore
        
        testResults = TestResults(
            score: score,
            correctAnswers: correctCount,
            totalQuestions: currentQuestions.count,
            wrongAnswers: wrongAnswers,
            passed: passed
        )
        
        testCompleted = true
        print("Test completed. Score: \(score)% (\(correctCount)/\(currentQuestions.count))")
    }
    
    /// Reset the test state
    func resetTest() {
        currentQuestions = []
        currentQuestionIndex = 0
        userAnswers = []
        testStarted = false
        testCompleted = false
        testResults = nil
        errorMessage = nil
    }
}
