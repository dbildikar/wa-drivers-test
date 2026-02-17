//
//  AnalyticsManager.swift
//  WADriversTest
//
//  Firebase Analytics Manager
//

import Foundation
import FirebaseAnalytics

class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    // MARK: - Screen Tracking
    
    func logScreenView(screenName: String, screenClass: String? = nil) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass ?? screenName
        ])
    }
    
    // MARK: - Test Events
    
    func logTestStarted(questionCount: Int) {
        Analytics.logEvent("test_started", parameters: [
            "question_count": questionCount
        ])
    }
    
    func logTestCompleted(score: Int, totalQuestions: Int, passed: Bool) {
        Analytics.logEvent("test_completed", parameters: [
            "score": score,
            "total_questions": totalQuestions,
            "percentage": (score * 100) / totalQuestions,
            "passed": passed
        ])
    }
    
    func logQuestionAnswered(questionId: String, isCorrect: Bool, timeSpent: Double? = nil) {
        var params: [String: Any] = [
            "question_id": questionId,
            "is_correct": isCorrect
        ]
        if let time = timeSpent {
            params["time_spent_seconds"] = time
        }
        Analytics.logEvent("question_answered", parameters: params)
    }
    
    // MARK: - User Actions
    
    func logDisclaimerAccepted() {
        Analytics.logEvent("disclaimer_accepted", parameters: nil)
    }
    
    func logAppLaunched() {
        Analytics.logEvent("app_launched", parameters: nil)
    }
    
    func logRetryTest() {
        Analytics.logEvent("retry_test", parameters: nil)
    }
    
    func logReturnToHome() {
        Analytics.logEvent("return_to_home", parameters: nil)
    }
}
