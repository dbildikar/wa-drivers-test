//
//  DisclaimerView.swift
//  WADriversTest
//
//  First-time disclaimer and terms of use screen
//

import SwiftUI

struct DisclaimerView: View {
    @Binding var hasAcceptedTerms: Bool
    @State private var hasScrolledToBottom = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
                Text("Important Disclaimer")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Please read before continuing")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            .padding(.bottom, 24)
            
            // Scrollable Terms Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DisclaimerSection(
                        icon: "building.columns",
                        title: "Not Affiliated with WA DOL",
                        content: "This application is NOT affiliated with, endorsed by, or connected to the Washington State Department of Licensing (DOL) or any government agency. This is an independent study tool created for educational purposes only."
                    )
                    
                    DisclaimerSection(
                        icon: "exclamationmark.circle",
                        title: "No Guarantee of Accuracy",
                        content: "While we strive to provide accurate and up-to-date information, we make NO guarantees regarding the accuracy, completeness, or currentness of the questions and answers in this app. Traffic laws and regulations may change, and this app may not reflect the most recent updates."
                    )
                    
                    DisclaimerSection(
                        icon: "book.closed",
                        title: "Practice Tool Only",
                        content: "This app is intended solely as a supplementary practice tool to help you prepare for your driver's license exam. It should NOT be used as your only source of study material. Success on practice tests does not guarantee success on the actual exam."
                    )
                    
                    DisclaimerSection(
                        icon: "link",
                        title: "Official Resources",
                        content: "For the most accurate and up-to-date information, always refer to the official Washington State Department of Licensing website and the official Washington Driver Guide."
                    )
                    
                    // Official Link
                    Link(destination: URL(string: "https://www.dol.wa.gov/driver-licenses-and-permits/driver-guide")!) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Visit Official WA DOL Website")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                    }
                    
                    DisclaimerSection(
                        icon: "hand.raised",
                        title: "Limitation of Liability",
                        content: "By using this app, you acknowledge that the developers and publishers shall not be held liable for any errors, omissions, or outcomes resulting from the use of this application. You use this app at your own risk."
                    )
                    
                    // Bottom spacer to ensure user scrolls
                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            // Accept Button
            VStack(spacing: 12) {
                Divider()
                
                Button(action: {
                    // Save acceptance to UserDefaults
                    UserDefaults.standard.set(true, forKey: "hasAcceptedTerms")
                    withAnimation {
                        hasAcceptedTerms = true
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("I Understand and Accept")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                
                Text("By tapping above, you agree to these terms")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .background(Color(.systemBackground))
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct DisclaimerSection: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 28)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 38)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    DisclaimerView(hasAcceptedTerms: .constant(false))
}
