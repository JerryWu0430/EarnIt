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
    
    private let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
        repeats: true,
        warningTime: DateComponents(minute: 5)
    )
        
    private let center = DeviceActivityCenter()
    private let activity = DeviceActivityName(ScreenTimeConstant.ActivityName)
    private let eventName = DeviceActivityEvent.Name(ScreenTimeConstant.EventName)
    
    var selectionToDiscourage = DataPersistence.shared.savedGroupSelection() ?? FamilyActivitySelection() {
        willSet {
            DataPersistence.shared.saveSelection(selection: newValue)
            
            // Debugging outputs
            print("New selection tokens: \(newValue.applicationTokens)")
            print("Current time limit: \(PublicVariable.timeLimit)")
            
            // Only start shielding if time left is less than or equal to 0
            if !newValue.applicationTokens.isEmpty && PublicVariable.timeLimit <= 0 {
                print("Starting shielding for applications.")
                ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            } else {
                print("Stopping shielding for applications.")
                ManagedSettingsStoreHelper.shared.stopApplicationsShielding()
            }
        }
    }
    
    private init() {
        isMonitoring = DataPersistence.shared.getMonitoringState()
        // DEBUGGING OUTPUTS
        // Start shielding immediately if apps are already selected
        //if !selectionToDiscourage.applicationTokens.isEmpty {
        //    ManagedSettingsStoreHelper.shared.startApplicationsShielding()
        //    PublicVariable.timeLimit = 0
        //}
    }

    func initiateMonitoring(timeLimit: Int) {
        guard timeLimit > 0 else {
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            return
        }
        
        DataPersistence.shared.saveMonitoringState(isMonitoring: true)
        ManagedSettingsStoreHelper.shared.stopApplicationsShielding() // Ensure apps are unblocked
        center.stopMonitoring()

        selectionToDiscourage = DataPersistence.shared.savedGroupSelection() ?? FamilyActivitySelection()
        
        let dateC = DateComponents(second: timeLimit)

        let event = DeviceActivityEvent(
            applications: selectionToDiscourage.applicationTokens,
            categories: selectionToDiscourage.categoryTokens,
            webDomains: selectionToDiscourage.webDomainTokens,
            threshold: dateC
        )

        do {
            try center.startMonitoring(activity, during: schedule, events: [eventName: event])
            PublicVariable.timeLimit = timeLimit
            print("Monitoring started with time limit: \(timeLimit)")
        } catch {
            print("Could not start monitoring \(error)")
            // If monitoring fails, shield the apps
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
        }
    }
    
    func stopMonitoring() {
        DataPersistence.shared.saveMonitoringState(isMonitoring: false)
        ManagedSettingsStoreHelper.shared.startApplicationsShielding() // Start shielding when monitoring stops
        center.stopMonitoring()
        PublicVariable.timeLimit = 0
    }

    func stopShielding() {
        ManagedSettingsStoreHelper.shared.stopApplicationsShielding()
    }
}
