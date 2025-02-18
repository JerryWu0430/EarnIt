import Foundation
import SwiftUI
import FamilyControls
import DeviceActivity

class TimeManager: ObservableObject {
    @Published var timeLeft: Int {
        didSet {
            UserDefaults.standard.set(timeLeft, forKey: "timeLeft")
            print("Time left updated: \(timeLeft)") // Debugging output
            
            // Update device activity monitoring when time changes
            if timeLeft > 0 {
                TimeLimitModel.shared.initiateMonitoring(timeLimit: timeLeft * 60) // Convert minutes to seconds
            } else {
                // Only stop monitoring and shield if time left is 0 or less
                TimeLimitModel.shared.stopMonitoring()
                ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            }
        }
    }
    
    @Published var timeEarned: Int {
        didSet {
            UserDefaults.standard.set(timeEarned, forKey: "timeEarned")
        }
    }
    
    @Published var totalScreenTime: Int {
        didSet {
            UserDefaults.standard.set(totalScreenTime, forKey: "totalScreenTime")
        }
    }
    
    init() {
        // Initialize properties first
        self.timeLeft = UserDefaults.standard.integer(forKey: "timeLeft")
        self.timeEarned = UserDefaults.standard.integer(forKey: "timeEarned")
        self.totalScreenTime = UserDefaults.standard.integer(forKey: "totalScreenTime")
        
        // Now it's safe to access self
        print("Initial time left: \(timeLeft)") // Debugging output
    }
    
    func addEarnedTime(_ minutes: Int) {
        timeEarned += minutes
        timeLeft += minutes
        totalScreenTime += minutes
        print("Added time: \(minutes). New time left: \(timeLeft)") // Debugging output
    }
    
    func useScreenTime(_ minutes: Int) {
        guard timeLeft >= minutes else { 
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            return 
        }
        timeLeft -= minutes
    }
    
    func formatTime(_ minutes: Int) -> String {
        return "\(minutes) min"
    }
} 
