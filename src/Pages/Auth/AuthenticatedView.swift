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
  @StateObject private var viewModel = AuthenticationViewModel()
  @State private var presentingLoginScreen = false
  @State private var presentingProfileScreen = false

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
    ZStack {
      switch viewModel.authenticationState {
      case .unauthenticated, .authenticating:
        if let unauthenticated {
          AnyView(unauthenticated)
            .environmentObject(viewModel)
            .environment(\.presentingLoginScreen, presentingLoginScreen)
            .environment(\.presentingLoginScreenBinding, $presentingLoginScreen)
        } else {
          Text("You're not logged in.")
        }
      case .authenticated:
        content()
      }
    }
    .sheet(isPresented: $presentingLoginScreen) {
      AuthenticationView()
        .environmentObject(viewModel)
    }
  }
}

struct AuthenticatedView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticatedView {
      Text("You're signed in.")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.yellow)
    }
  }
}
