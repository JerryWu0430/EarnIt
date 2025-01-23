//
//  ContentView.swift
//  ios
//
//  Created by Teodor Calin on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        AuthenticatedView(
            unauthenticated: {
                Splash()
            },
            content: {
                Home()
            }
        )
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
