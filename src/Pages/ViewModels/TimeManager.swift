import Foundation
import SwiftUI

class TimeManager: ObservableObject {
    @Published var timeLeft: Int {
        didSet {
            UserDefaults.standard.set(timeLeft, forKey: "timeLeft")
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
        guard timeLeft >= minutes else { return }
        timeLeft -= minutes
    }
    
    func formatTime(_ minutes: Int) -> String {
        return "\(minutes) min"
    }
} 