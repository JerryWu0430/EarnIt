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
            print("Time left updated: \(timeLeft)") // Debugging output
            
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
        self.timeLeft = authViewModel.selectedMode.timeLimit // Initialize with mode's time limit
        
        // Observe changes to selectedMode
        authViewModel.$selectedMode
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.resetForNewMode()
            }
            .store(in: &cancellables)
        
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
        // timeLeft is updated via timeEarned's didSet
        print("Added time: \(minutes). New time left: \(timeLeft)") // Debugging output
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
} 
