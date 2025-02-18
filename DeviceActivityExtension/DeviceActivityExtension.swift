//
//  DeviceActivityExtension.swift
//  DeviceActivityExtension
//
//  Created by Gabriel Bor on 17/09/2024.
//

import DeviceActivity
import SwiftUI

@main
struct DeviceActivityExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            return TotalActivityView(activityReport: totalActivity)
        }
        // Add more reports here...
    }
}
