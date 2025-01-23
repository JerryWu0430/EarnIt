//
//  AuthenticatedView.swift
//  ios
//
//  Created by Jerry Wu on 08/01/25.
//


import SwiftUI
import FirebaseAuth

private struct PresentingLoginScreenKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct PresentingLoginScreenBindingKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var presentingLoginScreen: Bool {
        get { self[PresentingLoginScreenKey.self] }
        set { self[PresentingLoginScreenKey.self] = newValue }
    }
    
    var presentingLoginScreenBinding: Binding<Bool> {
        get { self[PresentingLoginScreenBindingKey.self] }
        set { self[PresentingLoginScreenBindingKey.self] = newValue }
    }
}

struct AuthenticatedView<Content: View>: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @ViewBuilder var content: () -> Content
    let unauthenticated: () -> AnyView
    
    init(content: @escaping () -> Content, unauthenticated: @escaping () -> AnyView) {
        self.content = content
        self.unauthenticated = unauthenticated
    }
    
    var body: some View {
        if let _ = viewModel.user {
            if viewModel.showOnboarding {
                OnboardingFlow()
            } else {
                content()
            }
        } else {
            unauthenticated()
        }
    }
}

struct AuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedView(
            content: { Text("You're signed in.") },
            unauthenticated: { AnyView(Text("You're not signed in.")) }
        )
        .environmentObject(AuthenticationViewModel())
    }
}
