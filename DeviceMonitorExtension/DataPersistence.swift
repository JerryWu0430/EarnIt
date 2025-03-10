//
//  DataPersistence.swift
//  DeviceMonitorExtension
//
//  Created by Gabriel Bor on 04/09/2024.
//

import Foundation
import FamilyControls

class DataPersistence {
    
    public static let shared = DataPersistence()
    
    // Used to encode codable to UserDefaults
    private let encoder = PropertyListEncoder()
    
    // Used to decode codable from UserDefaults
    private let decoder = PropertyListDecoder()
    
    private let sharedApplicationsDataKey = "SharedTimeKey"
    private let isMonitoringKey = "IsMonitoring"
    
    private init() { }
    
    func saveSelection(selection: FamilyActivitySelection) {
        let sharedUserDefaults = UserDefaults(suiteName: "group.EarnIt")
        sharedUserDefaults?.set(try? encoder.encode(selection), forKey: sharedApplicationsDataKey)
        sharedUserDefaults?.synchronize()
    }
    
    func savedGroupSelection() -> FamilyActivitySelection? {
        let sharedUserDefaults = UserDefaults(suiteName: "group.EarnIt")
        
        guard let data = sharedUserDefaults?.data(forKey: sharedApplicationsDataKey) else { return nil }
        
        return try? decoder.decode(FamilyActivitySelection.self, from: data)
    }
    
    func saveMonitoringState(isMonitoring: Bool) {
        UserDefaults.standard.set(isMonitoring, forKey: isMonitoringKey)
    }
    
    func getMonitoringState() -> Bool {
        return UserDefaults.standard.bool(forKey: isMonitoringKey)
    }
}
