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
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Washington State")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("Drivers Test")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.top, 40)
                
                // Test Info Card
                VStack(alignment: .leading, spacing: 20) {
                    Text("Practice Test")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Take a practice test with **\(TestConfig.defaultQuestionCount) questions** to prepare for your Washington State driver's license exam.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "book.fill", text: "Real exam questions", color: .blue)
                        FeatureRow(icon: "lightbulb.fill", text: "Detailed explanations", color: .yellow)
                        FeatureRow(icon: "chart.bar.fill", text: "Instant results", color: .green)
                        FeatureRow(icon: "checkmark.circle.fill", text: "\(TestConfig.passingScore)% to pass", color: .orange)
                    }
                }
                .padding(24)
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
                
                // Start Button
                Button(action: {
                    testManager.startTest()
                    showingTest = true
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
                .padding(.horizontal)
                .disabled(testManager.isLoading)
                
                // Error message
                if let error = testManager.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer(minLength: 40)
                
                // Footer
                VStack(spacing: 4) {
                    Text("Not affiliated with WA DOL")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("© 2024 Washington State Drivers Test")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
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
