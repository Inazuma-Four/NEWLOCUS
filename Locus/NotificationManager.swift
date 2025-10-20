//
//  NotificationManager.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    private let constant = AppConstant()
    static let shared = NotificationManager()
    
    func checkNotifPermission() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func addWeeklyNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for dayIndex in 0..<constant.notificationTitle.count {
            let content = UNMutableNotificationContent()
            content.title = constant.notificationTitle[dayIndex]
            content.subtitle = constant.notificationDescription[dayIndex]
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 12
            dateComponents.minute = 44
            dateComponents.weekday = dayIndex + 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "notif-\(dayIndex)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification for day \(dayIndex): \(error.localizedDescription)")
                } else {
                    print("✅ Notification scheduled for day index \(dayIndex) at 8 PM")
                }
            }
        }
    }
    
    func removeNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

