//
//  MainPageView.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI
import SwiftData

struct MainPageView: View {
    
    @State var allHistory: Array = []
    
    var body: some View {
        VStack {
            if allHistory.count == 0 {
                HomeEmptyView()
            } else {
                HistoryMainView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationManager.shared.checkNotifPermission()
            NotificationManager.shared.addWeeklyNotifications()
        }
        //.appBackground()
    }
        
}

#Preview {
    MainPageView()
}
