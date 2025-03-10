import Foundation
import SwiftUI
import FamilyControls
import DeviceActivity
import Combine

@MainActor
class TimeManager: ObservableObject {
    @Published var timeLeft: Int {
        didSet {
            UserDefaults.standard.set(timeLeft, forKey: "timeLeft")
            print("Time left updated: \(timeLeft)")
            
            if timeLeft > 0 {
                TimeLimitModel.shared.initiateMonitoring(timeLimit: timeLeft * 60)
            } else {
                TimeLimitModel.shared.stopMonitoring()
                ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            }
        }
    }
    
    @Published var timeEarned: Int {
        didSet {
            UserDefaults.standard.set(timeEarned, forKey: "timeEarned")
            updateTimeLeft()
        }
    }
    
    @Published var timeSpentOnApps: Int = 0 {
        didSet {
            UserDefaults.standard.set(timeSpentOnApps, forKey: "timeSpentOnApps")
            updateTimeLeft()
        }
    }
    
    private let authViewModel: AuthenticationViewModel
    
    init(authViewModel: AuthenticationViewModel) {
        self.authViewModel = authViewModel
        self.timeSpentOnApps = UserDefaults.standard.integer(forKey: "timeSpentOnApps")
        self.timeEarned = UserDefaults.standard.integer(forKey: "timeEarned")
        self.timeLeft = authViewModel.selectedMode.timeLimit
        
        // Observe changes to selectedMode
        authViewModel.$selectedMode
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.resetForNewMode()
            }
            .store(in: &cancellables)
        
        // Observe time spent updates
        NotificationCenter.default.addObserver(
            forName: Notification.Name("UpdateTimeSpent"),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let minutes = notification.userInfo?["minutes"] as? Int {
                self?.updateTimeSpent(minutes)
            }
        }
        
        // Add observer for time reset
        NotificationCenter.default.addObserver(
            forName: Notification.Name("ResetTimeLeft"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.resetTime()
        }
        
        print("Initial time left: \(timeLeft)")
    }
    
    // Add property to store cancellables
    private var cancellables = Set<AnyCancellable>()
    
    private func resetForNewMode() {
        // Reset time spent and earned for new mode
        timeSpentOnApps = 0
        timeEarned = 0
        timeLeft = authViewModel.selectedMode.timeLimit
    }
    
    private func updateTimeLeft() {
        let initialTime = authViewModel.selectedMode.timeLimit
        timeLeft = initialTime + timeEarned - timeSpentOnApps
    }
    
    func addEarnedTime(_ minutes: Int) {
        timeEarned += minutes
        print("Added time: \(minutes). New time left: \(timeLeft)")
        
        if timeLeft > 0 {
            ManagedSettingsStoreHelper.shared.stopApplicationsShielding()
            TimeLimitModel.shared.initiateMonitoring(timeLimit: timeLeft * 60)
        }
    }
    
    func updateTimeSpent(_ minutes: Int) {
        timeSpentOnApps = minutes
        // timeLeft is updated via timeSpentOnApps's didSet
    }
    
    func useScreenTime(_ minutes: Int) {
        guard timeLeft >= minutes else { 
            ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            return 
        }
        updateTimeSpent(timeSpentOnApps + minutes)
    }
    
    func formatTime(_ minutes: Int) -> String {
        return "\(minutes) min"
    }
    
    func setTimeForSelectedMode(_ timeLimit: Int) {
        updateTimeLeft() // This will use the new mode's time limit
    }
    
    func calculateEarnedMinutes(correctAnswers: Int) -> Int {
        switch authViewModel.selectedMode {
        case .focus:
            // Every 5 questions = 1 minute
            return correctAnswers / 5
        case .balanced:
            // Every question = 1 minute
            return correctAnswers
        case .reward:
            // Every question = 5 minutes
            return correctAnswers * 5
        }
    }
    
    // Add new function to reset time
    private func resetTime() {
        timeSpentOnApps = 0
        timeEarned = 0
        timeLeft = 0  // Reset to 0 instead of mode's time limit
        
        // Save the reset values
        UserDefaults.standard.set(timeSpentOnApps, forKey: "timeSpentOnApps")
        UserDefaults.standard.set(timeEarned, forKey: "timeEarned")
        UserDefaults.standard.set(timeLeft, forKey: "timeLeft")
    }
} 
