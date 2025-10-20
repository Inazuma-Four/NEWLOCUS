//
//  HistoryMainView.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 18/10/25.
//

import SwiftUI

struct HistoryMainView: View {
    var body: some View {
        VStack {
            Text("Hello World")
        }
        .onAppear{
            NotificationManager.shared.checkNotifPermission()
            NotificationManager.shared.addWeeklyNotifications()
        }
    }
}

#Preview {
    HistoryMainView()
}
