//
//  TotalActivityView.swift
//  DeviceActivityExtension
//
//  Created by Gabriel Bor on 17/09/2024.
//

import SwiftUI

struct TotalActivityView: View {
    var activityReport: ActivityReport
    var timeLimit = PublicVariable.timeLimit
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Total Screen Time: \(activityReport.totalDuration.stringFromTimeInterval())")
            
            
            Text("Time on selected apps: \(activityReport.totalSelectedDuration.stringFromTimeInterval())")
            
            List(activityReport.apps) { app in
                ListRow(eachApp: app)
            }
            .listStyle(PlainListStyle())
            .frame(height: 150)
            
//            Text(activityReport.totalSelectedDuration.stringFromTimeInterval())
            Text(Double(timeLimit).stringFromTimeInterval())
            let updatedTimeInterval: TimeInterval = activityReport.totalSelectedDuration - TimeInterval(timeLimit)
            Text("Time on selected apps: \(updatedTimeInterval.stringFromTimeInterval())")
            
        }
    }
}

struct ListRow: View {
    var eachApp: AppDeviceActivity
    var body: some View {
        HStack(spacing: 0) {
            Text(eachApp.displayName)
            Spacer()
            Text(String(eachApp.duration.stringFromTimeInterval()))
        }
    }
}

struct SelectedAppsView: View {
    var activityReport: ActivityReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if activityReport.apps.isEmpty {
                Text("No apps selected")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(activityReport.apps) { app in
                    HStack {
                        Image(systemName: "app.fill")
                            .foregroundColor(.blue)
                        Text(app.displayName)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    if app.id != activityReport.apps.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
