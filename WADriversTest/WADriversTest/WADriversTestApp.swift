//
//  WADriversTestApp.swift
//  WADriversTest
//
//  Washington State Drivers License Practice Test iOS App
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore

@main
struct WADriversTestApp: App {
    
    init() {
        // Initialize Firebase
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Initialize Google Mobile Ads SDK in background
                    DispatchQueue.global(qos: .background).async {
                        GADMobileAds.sharedInstance().start(completionHandler: nil)
                    }
                    
                    // Log app launch
                    AnalyticsManager.shared.logAppLaunched()
                }
        }
    }
}
