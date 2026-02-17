//
//  HomeView.swift
//  WADriversTest
//
//  Home screen with test information and start button
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var testManager: TestManager
    @Binding var showingTest: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Washington State")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text("Drivers Test")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 30)
                    
                    // Test Info Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Practice Test")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("Take a practice test with **\(TestConfig.defaultQuestionCount) questions** to prepare for your Washington State driver's license exam.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        // Features
                        VStack(alignment: .leading, spacing: 12) {
                            FeatureRow(icon: "book.fill", text: "Real exam questions", color: .blue)
                            FeatureRow(icon: "lightbulb.fill", text: "Detailed explanations", color: .yellow)
                            FeatureRow(icon: "chart.bar.fill", text: "Instant results", color: .green)
                            FeatureRow(icon: "checkmark.circle.fill", text: "\(TestConfig.passingScore)% to pass", color: .orange)
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Question Count Info
                    if QuestionDatabase.shared.count > 0 {
                        Text("\(QuestionDatabase.shared.count)+ questions available")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Footer
                    VStack(spacing: 4) {
                        Text("Not affiliated with WA DOL")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("© 2024 Washington State Drivers Test")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
            }
            
            // Fixed Start Button at bottom
            VStack(spacing: 8) {
                // Error message
                if let error = testManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    testManager.startTest()
                    showingTest = true
                    // Log analytics event
                    AnalyticsManager.shared.logTestStarted(questionCount: testManager.totalQuestions)
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Practice Test")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(testManager.isLoading)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color(.systemGroupedBackground))
            
            // Ad Banner at bottom
            AdBannerContainer()
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            AnalyticsManager.shared.logScreenView(screenName: "Home")
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    HomeView(testManager: TestManager(), showingTest: .constant(false))
}
