//
//  Onboarding_Orchestrator.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_Orchestrator: View {
    @State private var currentStep = 1
    
    var body: some View {
        OnboardingFlow()
            .environmentObject(AuthenticationViewModel())
    }
}

#Preview {
    Onboarding_Orchestrator()
}
