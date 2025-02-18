//
//  AppDeviceActivity.swift
//  DeviceActivityExtension
//
//  Created by Gabriel Bor on 17/09/2024.
//

import SwiftUI

struct ActivityReport {
    let totalDuration: TimeInterval
    let apps: [AppDeviceActivity]
    let totalSelectedDuration: TimeInterval
}

struct AppDeviceActivity: Identifiable {
    var id: String
    var displayName: String
    var duration: TimeInterval
    var numberOfPickups: Int
}

extension TimeInterval{
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let hours = time / 3600
        let minutes = (time  % 3600) / 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
