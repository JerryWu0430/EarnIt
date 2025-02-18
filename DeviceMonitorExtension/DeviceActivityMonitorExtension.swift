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
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        print("Interval Did Start")
        scheduleNotification(with: "interval did start")

    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        print("Interval Did End")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        print("Threshold reached")
        scheduleNotification(with: "event did reach threshold warning")
        
        if event.rawValue == ScreenTimeConstant.EventName || activity.rawValue == ScreenTimeConstant.ActivityName {
            PublicVariable.timeLimit = 0
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
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
        
        print("Threshold Is Coming")
        scheduleNotification(with: "event will reach threshold warning")
    }

}

func scheduleNotification(with title: String) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            let content = UNMutableNotificationContent()
            content.title = title // Using the custom title here
            content.body = "Here is the body text of the notification."
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 5 seconds from now
            
            let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        } else {
            print("Permission denied. \(error?.localizedDescription ?? "")")
        }
    }
}
