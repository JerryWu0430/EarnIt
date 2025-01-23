//
//  AuthenticationView.swift
//  ios
//
//  Created by Jerry Wu on 08/01/25.
//


import SwiftUI
import Combine

struct AuthenticationView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Binding var isPresented: Bool

  var body: some View {
    print("Current flow: \(viewModel.flow)")
    return VStack {
      switch viewModel.flow {
      case .splash:
        Splash()
          .environmentObject(viewModel)
      case .login:
        Login()
          .environmentObject(viewModel)
      case .register:
        Register(rootIsPresented: $isPresented)
          .environmentObject(viewModel)
      }
    }
  }
}

struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView(isPresented: .constant(true))
      .environmentObject(AuthenticationViewModel())
  }
}
