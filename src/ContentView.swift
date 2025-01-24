//
//  ContentView.swift
//  ios
//
//  Created by Teodor Calin on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showingAuthentication = true

    var body: some View {
        Group {
            if viewModel.authenticationState == .authenticated {
                if viewModel.showOnboarding {
                    OnboardingFlow()
                } else {
                    Home()
                }
            } else {
                AuthenticationView(isPresented: $showingAuthentication)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
