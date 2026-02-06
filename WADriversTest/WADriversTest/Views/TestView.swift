//
//  TestView.swift
//  WADriversTest
//
//  The main test-taking view with questions and answers
//

import SwiftUI

struct TestView: View {
    @ObservedObject var testManager: TestManager
    @Binding var showingResults: Bool
    @Binding var showingTest: Bool
    
    @State private var showingExitAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with progress
            TestHeader(
                currentQuestion: testManager.currentQuestionNumber,
                totalQuestions: testManager.totalQuestions,
                progress: testManager.progress,
                onExit: { showingExitAlert = true }
            )
            
            // Question content
            ScrollView {
                VStack(spacing: 24) {
                    if let question = testManager.currentQuestion {
                        QuestionCard(
                            question: question,
                            selectedAnswer: testManager.selectedAnswer,
                            onSelectAnswer: { index in
                                testManager.answerQuestion(answerIndex: index)
                            }
                        )
                    }
                }
                .padding()
            }
            
            // Navigation buttons
            NavigationButtons(
                canGoBack: testManager.canGoToPrevious,
                canGoForward: testManager.canGoToNext,
                isLastQuestion: testManager.isLastQuestion,
                canSubmit: testManager.canSubmit,
                onPrevious: { _ = testManager.previousQuestion() },
                onNext: { _ = testManager.nextQuestion() },
                onSubmit: {
                    testManager.submitTest()
                    showingResults = true
                }
            )
        }
        .background(Color(.systemGroupedBackground))
        .alert("Exit Test?", isPresented: $showingExitAlert) {
            Button("Continue Test", role: .cancel) { }
            Button("Exit", role: .destructive) {
                testManager.resetTest()
                showingTest = false
            }
        } message: {
            Text("Your progress will be lost if you exit now.")
        }
    }
}

struct TestHeader: View {
    let currentQuestion: Int
    let totalQuestions: Int
    let progress: Double
    let onExit: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onExit) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Question \(currentQuestion) of \(totalQuestions)")
                    .font(.headline)
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 4)
        }
        .padding(.top, 8)
        .background(Color(.systemBackground))
    }
}

struct QuestionCard: View {
    let question: Question
    let selectedAnswer: Int?
    let onSelectAnswer: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Category badge
            Text(question.category)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
            
            // Question text
            Text(question.questionText)
                .font(.title3)
                .fontWeight(.semibold)
                .fixedSize(horizontal: false, vertical: true)
            
            // Answer options
            VStack(spacing: 12) {
                ForEach(Array(question.answerOptions.enumerated()), id: \.offset) { index, option in
                    AnswerButton(
                        text: option,
                        isSelected: selectedAnswer == index,
                        action: { onSelectAnswer(index) }
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NavigationButtons: View {
    let canGoBack: Bool
    let canGoForward: Bool
    let isLastQuestion: Bool
    let canSubmit: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Previous button
            Button(action: onPrevious) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Previous")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(canGoBack ? .primary : .secondary)
                .cornerRadius(12)
            }
            .disabled(!canGoBack)
            
            // Next or Submit button
            if isLastQuestion && canSubmit {
                Button(action: onSubmit) {
                    HStack {
                        Text("Submit")
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            } else {
                Button(action: onNext) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canGoForward ? Color.blue : Color(.systemGray5))
                    .foregroundColor(canGoForward ? .white : .secondary)
                    .cornerRadius(12)
                }
                .disabled(!canGoForward)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    TestView(
        testManager: TestManager(),
        showingResults: .constant(false),
        showingTest: .constant(true)
    )
}
