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
    
    var body: some View {
        Group {
            if !hasAcceptedTerms {
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
                .onAppear {
                    testManager.loadQuestions()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: hasAcceptedTerms)
    }
}

#Preview {
    ContentView()
}
