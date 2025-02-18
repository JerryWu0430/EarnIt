//
//  TimeLimitModel.swift
//  DeviceMonitorExtension
//
//  Created by Gabriel Bor on 04/09/2024.
//

import Foundation
import FamilyControls
import DeviceActivity

class TimeLimitModel: ObservableObject {
    
    static let shared = TimeLimitModel()
    
    @Published var isMonitoring = false
    
    var selectionToDiscourage = DataPersistence.shared.savedGroupSelection() ?? FamilyActivitySelection() {
        willSet {
            DataPersistence.shared.saveSelection(selection: newValue)
            
            if !newValue.applicationTokens.isEmpty && PublicVariable.timeLimit <= 0 {
                print("Starting shielding for applications.")
                ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            } else {
                print("Stopping shielding for applications.")
                ManagedSettingsStoreHelper.shared.stopApplicationsShielding()
            }
        }
    }
    
    private let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
        repeats: true,
        warningTime: DateComponents(minute: 5)
    )
        
    private let center = DeviceActivityCenter()
    private let activity = DeviceActivityName(ScreenTimeConstant.ActivityName)
    private let eventName = DeviceActivityEvent.Name(ScreenTimeConstant.EventName)
    
    private var timer: Timer?
    private var cumulativeUsage: Int = 0
    
    private init() {
        isMonitoring = DataPersistence.shared.getMonitoringState()
    }

    func initiateMonitoring(timeLimit: Int) {
        guard timeLimit > 0 else {
            print("⚠️ Time limit is 0, not starting monitoring")
            return
        }
        
        print("🔄 Starting monitoring setup...")
        
        DataPersistence.shared.saveMonitoringState(isMonitoring: true)
        ManagedSettingsStoreHelper.shared.stopApplicationsShielding()
        center.stopMonitoring()
        
        let dateC = DateComponents(second: timeLimit)
        let event = DeviceActivityEvent(
            applications: selectionToDiscourage.applicationTokens,
            categories: selectionToDiscourage.categoryTokens,
            webDomains: selectionToDiscourage.webDomainTokens,
            threshold: dateC
        )
        
        do {
            try center.startMonitoring(activity, during: schedule, events: [eventName: event])
            print("✅ Monitoring started successfully")
            print("⏱️ Time limit: \(timeLimit) seconds")
            print("🎯 Event name: \(eventName.rawValue)")
            PublicVariable.timeLimit = timeLimit
            startTimer()
        } catch {
            print("❌ Failed to start monitoring: \(error)")
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        cumulativeUsage = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            print("Timer check - isUsingMonitoredApps: \(DeviceActivityMonitorExtension.isUsingMonitoredApps)")
            if DeviceActivityMonitorExtension.isUsingMonitoredApps {
                self.cumulativeUsage += 1
                print("⏱️ Time elapsed: \(self.cumulativeUsage) minutes")
                NotificationCenter.default.post(
                    name: Notification.Name("UpdateTimeSpent"),
                    object: nil,
                    userInfo: ["minutes": self.cumulativeUsage]
                )
            }
        }
    }
    
    func stopMonitoring() {
        print("🛑 Stopping monitoring")
        timer?.invalidate()
        timer = nil
        cumulativeUsage = 0
        DataPersistence.shared.saveMonitoringState(isMonitoring: false)
        center.stopMonitoring()
        PublicVariable.timeLimit = 0
    }

    func stopShielding() {
        ManagedSettingsStoreHelper.shared.stopApplicationsShielding()
    }
}
