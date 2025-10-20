//
//  LocusApp.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI

@main
struct LocusApp: App {
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    @State private var splashScreen = true
    
    var body: some Scene {
        WindowGroup {
            if splashScreen {
                SplashScreenView(isFirst: $splashScreen)
            }else {
                NavigationStack {
                    if hasSeenOnboarding {
                        HomeEmptyView()
                        //MainPageView()
                    } else {
                        OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    }
                }
            }
        }
    }
}
