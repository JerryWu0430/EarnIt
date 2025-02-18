//
//  ShieldConfigurationExtension.swift
//  ShieldConfig
//
//  Created by Gabriel Bor on 05/09/2024.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import SwiftUI

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon:
                UIImage(systemName: "book")?.withTintColor(UIColor.white),
            title:
                ShieldConfiguration.Label(
                    text: "EarnIt",
                    color: .white
                ),
            subtitle:
                ShieldConfiguration.Label(
                    text: "Go back and do some more work to get more time on \(String(describing: application.localizedDisplayName).dropFirst(10).dropLast(2))",
                    color: .white
                ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "close", color: .white),
            primaryButtonBackgroundColor: .red,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "EarnIt", color: UIColor(Color("AccentColor")))
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.dark,
            backgroundColor: UIColor.black,
            icon:
                UIImage(systemName: "book")?.withTintColor(UIColor.white),
            title:
                ShieldConfiguration.Label(
                    text: "EarnIt",
                    color: .white
                ),
            subtitle:
                ShieldConfiguration.Label(
                    text: "Go back and do some more work to get more time on \(String(describing: application.localizedDisplayName).dropFirst(10).dropLast(2))",
                    color: .white
                ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "close", color: .white),
            primaryButtonBackgroundColor: .red,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "EarnIt", color: UIColor(Color("AccentColor")))
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
