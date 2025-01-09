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

  var body: some View {
    VStack {
      switch viewModel.flow {
      case .login:
        Login()
          .environmentObject(viewModel)
      case .signUp:
        Register()
          .environmentObject(viewModel)
      }
    }
  }
}

struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView()
      .environmentObject(AuthenticationViewModel())
  }
}
