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
            TotalActivityView(activityReport: totalActivity)
        }
        // Add our new simplified report
        SelectedAppsList { selectedApps in
            SelectedAppsView(activityReport: selectedApps)
        }
        // Add more reports here...
    }
}
