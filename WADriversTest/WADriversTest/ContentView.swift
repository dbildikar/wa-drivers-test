//
//  ContentView.swift
//  WADriversTest
//
//  Main content view that manages navigation between screens
//

import SwiftUI

struct ContentView: View {
    @StateObject private var testManager = TestManager()
    @State private var showingTest = false
    @State private var showingResults = false
    @State private var hasAcceptedTerms = UserDefaults.standard.bool(forKey: "hasAcceptedTerms")
    @State private var isLoading = true
    @State private var loadingProgress: Double = 0.0
    
    var body: some View {
        Group {
            if isLoading {
                // Show splash with progress indicator
                SplashView(progress: $loadingProgress)
            } else if !hasAcceptedTerms {
                // Show disclaimer on first launch
                DisclaimerView(hasAcceptedTerms: $hasAcceptedTerms)
            } else {
                // Main app content
                NavigationStack {
                    Group {
                        if showingResults && testManager.testCompleted {
                            ResultsView(
                                testManager: testManager,
                                showingTest: $showingTest,
                                showingResults: $showingResults
                            )
                        } else if showingTest && testManager.testStarted {
                            TestView(
                                testManager: testManager,
                                showingResults: $showingResults,
                                showingTest: $showingTest
                            )
                        } else {
                            HomeView(
                                testManager: testManager,
                                showingTest: $showingTest
                            )
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showingTest)
                    .animation(.easeInOut(duration: 0.3), value: showingResults)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: hasAcceptedTerms)
        .animation(.easeInOut(duration: 0.5), value: isLoading)
        .onAppear {
            loadQuestions()
        }
    }
    
    private func loadQuestions() {
        let totalSteps = 10
        var currentStep = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            currentStep += 1
            withAnimation(.easeInOut(duration: 0.1)) {
                loadingProgress = Double(currentStep) / Double(totalSteps)
            }
            
            if currentStep == totalSteps / 2 {
                Task { @MainActor in
                    testManager.loadQuestions()
                }
            }
            
            if currentStep >= totalSteps {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
