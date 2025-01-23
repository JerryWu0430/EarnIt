//
//  AuthenticatedView.swift
//  ios
//
//  Created by Jerry Wu on 08/01/25.
//


import SwiftUI

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

extension AuthenticatedView where Unauthenticated == EmptyView {
  init(@ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = nil
    self.content = content
  }
}

struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var presentingLoginScreen = false

    var unauthenticated: Unauthenticated?
    @ViewBuilder var content: () -> Content

    public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated
        self.content = content
    }

    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated()
        self.content = content
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.authenticationState {
                case .unauthenticated, .authenticating:
                    if let unauthenticated = unauthenticated {
                        AnyView(unauthenticated)
                    } else {
                        Text("You're not logged in.")
                    }
                case .authenticated:
                    content()
                }
            }
            .sheet(isPresented: $presentingLoginScreen) {
                AuthenticationView(isPresented: $presentingLoginScreen)
                    .environmentObject(viewModel)
            }
        }
        .environment(\.presentingLoginScreen, presentingLoginScreen)
        .environment(\.presentingLoginScreenBinding, $presentingLoginScreen)
    }
}

struct AuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedView {
            Text("You're signed in.")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(.yellow)
        }
        .environmentObject(AuthenticationViewModel())
    }
}
