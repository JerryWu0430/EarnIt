//
//  Login.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI
import Combine
import FirebaseAnalytics


private enum FocusableField: Hashable {
    case email
    case password
    
}

struct Login: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    @State private var showingForgotPasswordAlert = false
    @State private var isResettingPassword = false

    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                viewModel.authenticationState = .authenticated
                dismiss()
            }
        }
    }

    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                viewModel.authenticationState = .authenticated
                dismiss()
            }
        }
    }

    private func resetPassword() {
        Task {
            isResettingPassword = true
            await viewModel.resetPassword()
            isResettingPassword = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { dismiss() }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .left)
                }
                Spacer()
            }.padding(.leading)
            
            Text("Welcome Back!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            Text("Sign in to continue")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.gray)
                .padding([.leading, .bottom])
            
            CustomTextInput(text: $viewModel.email, label: "Email")
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($focus, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    self.focus = .password
                }
                .padding(.bottom)
            
            CustomTextInput(text: $viewModel.password, label: "Password", protected: true)
                .focused($focus, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    signInWithEmailPassword()
                }
                .padding(.bottom)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(Color(UIColor.systemRed))
                    .padding(.horizontal)
            }

            Button(action: {
                showingForgotPasswordAlert = true
            }) {
                Text("Forgot Password?")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            .padding(.horizontal)
            .alert("Reset Password", isPresented: $showingForgotPasswordAlert) {
                Button("Cancel", role: .cancel) { }
                Button(isResettingPassword ? "Sending..." : "Reset") {
                    if !isResettingPassword {
                        resetPassword()
                    }
                }
                .disabled(viewModel.email.isEmpty || isResettingPassword)
            } message: {
                Text("We'll send a password reset link to \(viewModel.email). Make sure your email is correct.")
            }
            
            Button(action: signInWithEmailPassword) {
                CustomButton(buttonType: .full, text: viewModel.authenticationState != .authenticating ? "Sign In" : "Loading...")
            }
            .disabled(!viewModel.isValid)
            .padding([.horizontal, .bottom])
            
            HStack {
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(height:1)
                Text("or sign in with")
                    .foregroundStyle(.gray)
                    .font(.caption2)
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(height:1)
            }.padding(.horizontal)
            
            Button(action: signInWithGoogle) {
                SocialButton(buttonType: .Google, text: "Sign in with google")
            }
            .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Don't have an account? ")
                NavigationLink(destination: Register(rootIsPresented: .constant(false))) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                }
                Spacer()
            }
        }
        .analyticsScreen(name: "\(Self.self)")
    }
}

#Preview {
    NavigationView {
        Login()
            .environmentObject(AuthenticationViewModel())
    }
}
