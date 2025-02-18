//
//  DeviceActivityMonitorExtension.swift
//  DeviceMonitorExtension
//
//  Created by Gabriel Bor on 04/09/2024.
//

import DeviceActivity
import FamilyControls
import UserNotifications
import ManagedSettings
import Foundation
import UIKit
import MobileCoreServices

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    static var isUsingMonitoredApps = false
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("🔍 Interval Start Called - Activity: \(activity.rawValue)")
        
        DeviceActivityMonitorExtension.isUsingMonitoredApps = true
        print("✅ isUsingMonitoredApps set to true")
        
        scheduleNotification(
            title: "App Usage Started",
            body: "You started using a monitored app. Time limit: \(PublicVariable.timeLimit/60) minutes",
            identifier: "AppStartNotification"
        )
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("🔍 Interval End Called - Activity: \(activity.rawValue)")
        
        DeviceActivityMonitorExtension.isUsingMonitoredApps = false
        print("❌ isUsingMonitoredApps set to false")
        
        scheduleNotification(
            title: "App Usage Ended",
            body: "You've stopped using the monitored app",
            identifier: "AppEndNotification"
        )
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("⚠️ Threshold reached for event: \(event.rawValue)")
        
        if event.rawValue == ScreenTimeConstant.EventName {
            print("🎯 Matched event name: \(ScreenTimeConstant.EventName)")
            
            // Reset time limit to 0
            PublicVariable.timeLimit = 0
            
            // Post notification to reset time in TimeManager
            NotificationCenter.default.post(
                name: Notification.Name("ResetTimeLeft"),
                object: nil
            )
            
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            
            scheduleNotification(
                title: "Time Limit Reached!",
                body: "You've used up your allocated time. Complete quizzes to earn more time!",
                identifier: "TimeLimitNotification"
            )
        }
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        print("⏰ Warning for event: \(event.rawValue)")
        
        scheduleNotification(
            title: "Time Running Low",
            body: "You have about 5 minutes of app time remaining. Complete more quizzes to earn more time!",
            identifier: "TimeWarningNotification"
        )
    }

}

func scheduleNotification(title: String, body: String, identifier: String) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            
            // Show notification immediately
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("❌ Error scheduling notification: \(error)")
                } else {
                    print("✅ Notification scheduled: \(title)")
                }
            }
        } else {
            print("❌ Notification permission denied: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
