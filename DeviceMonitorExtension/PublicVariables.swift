//
//  PublicVariables.swift
//  DeviceMonitorExtension
//
//  Created by Gabriel Bor on 04/09/2024.
//

import Foundation

struct PublicVariable {
    
    static let appGroupID = "group.EarnIt"
    
    public static var timeLimit: Int {
        //seconds
            get {
                let userDefaults = UserDefaults(suiteName: appGroupID)
                return userDefaults?.integer(forKey: "timeLimit") ?? 0
            }
            set {
                let userDefaults = UserDefaults(suiteName: appGroupID)
                userDefaults?.set(newValue, forKey: "timeLimit")
            }
        }
}
