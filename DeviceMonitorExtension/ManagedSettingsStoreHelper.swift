//
//  ManagedSettingsStoreHelper.swift
//  DeviceMonitorExtension
//
//  Created by Gabriel Bor on 04/09/2024.
//

import ManagedSettings
import FamilyControls

class ManagedSettingsStoreHelper {
    
    public static let shared = ManagedSettingsStoreHelper()
    
    private let store = ManagedSettingsStore()
    
    init() {}
    
    func stopApplicationsShielding() {
        print("Stopping shielding for applications")
        
        store.shield.applications?.removeAll()
        store.shield.webDomains?.removeAll()
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific([], except: Set())
    }
    
    func startApplicationsShielding() {
        print("Start Shielding")
           
        let selectionToDiscourage = DataPersistence.shared.savedGroupSelection() ?? FamilyActivitySelection()
        
        store.shield.applications = selectionToDiscourage.applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens, except: Set())
        store.shield.webDomains = selectionToDiscourage.webDomainTokens
    }
    
    
    private func restrictDefaultFunctionalities() {
//        store.dateAndTime.requireAutomaticDateAndTime = true
//        store.account.lockAccounts = true
//        store.passcode.lockPasscode = true
//        store.siri.denySiri = true
//        store.appStore.denyInAppPurchases = true
//        store.appStore.maximumRating = 200
//        store.appStore.requirePasswordForPurchases = true
//        store.media.denyExplicitContent = true
//        store.gameCenter.denyMultiplayerGaming = true
//        store.media.denyMusicService = false
    }
}


