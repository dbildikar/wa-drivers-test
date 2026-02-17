//
//  ResultsView.swift
//  WADriversTest
//
//  Displays test results with score and wrong answers review
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var testManager: TestManager
    @Binding var showingTest: Bool
    @Binding var showingResults: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let results = testManager.testResults {
                    // Score Card
                    ScoreCard(results: results)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            testManager.resetTest()
                            testManager.startTest()
                            showingResults = false
                            // Log analytics event
                            AnalyticsManager.shared.logRetryTest()
                            AnalyticsManager.shared.logTestStarted(questionCount: testManager.totalQuestions)
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Take Another Test")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            testManager.resetTest()
                            showingResults = false
                            showingTest = false
                            // Log analytics event
                            AnalyticsManager.shared.logReturnToHome()
                        }) {
                            Text("Back to Home")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray5))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Wrong Answers Section
                    if !results.wrongAnswers.isEmpty {
                        WrongAnswersSection(wrongAnswers: results.wrongAnswers)
                    } else {
                        PerfectScoreCard()
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            AnalyticsManager.shared.logScreenView(screenName: "Results")
            if let results = testManager.testResults {
                AnalyticsManager.shared.logTestCompleted(
                    score: results.correctAnswers,
                    totalQuestions: results.totalQuestions,
                    passed: results.passed
                )
            }
        }
    }
}

struct ScoreCard: View {
    let results: TestResults
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Test Complete!")
                .font(.title2)
                .fontWeight(.bold)
            
            // Score circle
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: CGFloat(results.score) / 100)
                    .stroke(
                        results.passed ? Color.green : Color.red,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.0), value: results.score)
                
                VStack(spacing: 4) {
                    Text("\(results.score)%")
                        .font(.system(size: 44, weight: .bold))
                    
                    Text("\(results.correctAnswers)/\(results.totalQuestions)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 160, height: 160)
            .padding()
            
            // Pass/Fail badge
            Text(results.passed ? "PASSED!" : "FAILED - Need \(TestConfig.passingScore)% to pass")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(results.passed ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .foregroundColor(results.passed ? .green : .red)
                .cornerRadius(20)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
}

struct PerfectScoreCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text("Perfect Score!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Excellent work! You answered every question correctly.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.1), Color.green.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct WrongAnswersSection: View {
    let wrongAnswers: [WrongAnswer]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Questions You Missed")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ForEach(wrongAnswers) { wrongAnswer in
                WrongAnswerCard(wrongAnswer: wrongAnswer)
            }
        }
    }
}

struct WrongAnswerCard: View {
    let wrongAnswer: WrongAnswer
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with question number and category
            HStack {
                Text("Question \(wrongAnswer.questionIndex)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(6)
                
                Text(wrongAnswer.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            // Question text
            Text(wrongAnswer.question)
                .font(.subheadline)
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
            
            // Answers comparison
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your Answer:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(wrongAnswer.userAnswer)
                            .font(.subheadline)
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Correct Answer:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(wrongAnswer.correctAnswer)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
            
            // Expandable explanation
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Explanation")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text(wrongAnswer.explanation)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text("Source: \(wrongAnswer.source)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

#Preview {
    ResultsView(
        testManager: TestManager(),
        showingTest: .constant(true),
        showingResults: .constant(true)
    )
}
