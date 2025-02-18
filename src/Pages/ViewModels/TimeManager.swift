import Foundation
import SwiftUI
import FamilyControls
import DeviceActivity

class TimeManager: ObservableObject {
    @Published var timeLeft: Int {
        didSet {
            UserDefaults.standard.set(timeLeft, forKey: "timeLeft")
            // Update device activity monitoring when time changes
            if timeLeft > 0 {
                TimeLimitModel.shared.initiateMonitoring(timeLimit: timeLeft * 60) // Convert minutes to seconds
            } else {
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
        self.timeLeft = UserDefaults.standard.integer(forKey: "timeLeft")
        self.timeEarned = UserDefaults.standard.integer(forKey: "timeEarned")
        self.totalScreenTime = UserDefaults.standard.integer(forKey: "totalScreenTime")
    }
    
    func addEarnedTime(_ minutes: Int) {
        timeEarned += minutes
        timeLeft += minutes
        totalScreenTime += minutes
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