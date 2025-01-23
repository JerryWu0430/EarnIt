//
//  Login.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI
import Combine
import FirebaseAnalytics
import FirebaseAuth

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct Register: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var navigateToPendingVerification = false
    @Binding var rootIsPresented: Bool

    @FocusState private var focus: FocusableField?

    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
                print("Sign-up successful, navigating to PendingVerificationView")
                navigateToPendingVerification = true
            } else {
                print("Sign-up failed")
            }
        }
    }
    
    private func signUpWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                viewModel.showOnboarding = true
                rootIsPresented = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                HStack{
                    Button(action: { 
                        dismiss()
                        viewModel.flow = .splash
                    }) {
                        CustomButton(buttonType: .arrow, arrowDirection: .left)
                    }
                    Spacer()
                }.padding(.leading)
                
                Text("Hi!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                Text("Create a new account")
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
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
                    .padding(.bottom)
                
                CustomTextInput(text: $viewModel.confirmPassword, label: "Confirm Password", protected: true)
                    .focused($focus, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit {
                        signUpWithEmailPassword()
                    }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                        .padding(.horizontal)
                }

                HStack{
                    Spacer()
                    Text("Accept sign up with our privacy policy and Terms and Conditions")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                    Spacer()
                }.padding(.vertical)
                
                CustomButton(buttonType: .full, text: viewModel.authenticationState != .authenticating ? "Sign Up" : "Loading...")
                    .disabled(!viewModel.isValid || viewModel.authenticationState == .authenticating)
                    .onTapGesture {
                        signUpWithEmailPassword()
                    }
                    .padding([.horizontal,.bottom])
                
                HStack{
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height:1)
                    Text("or sign up with")
                        .foregroundStyle(.gray)
                        .font(.caption2)
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height:1)
                }.padding(.horizontal)
                
                SocialButton(buttonType: .Google, text: "Sign up with google"){
                    signUpWithGoogle()
                    }
                    .padding()
                
                Spacer()
                
                HStack{
                    Spacer()
                    Text("Have an account already? ")
                    Button(action: { viewModel.switchFlow() }) {
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                    Spacer()
                }

                NavigationLink(destination: PendingVerificationView(rootIsPresented: $rootIsPresented), isActive: $navigateToPendingVerification) {
                    EmptyView()
                }
                .hidden()
            }
            .analyticsScreen(name: "\(Self.self)")
            .onChange(of: viewModel.authenticationState) { newState in
                if newState == .pendingVerification {
                    navigateToPendingVerification = true
                }
            }
        }
    }
}

#Preview {
    Register(rootIsPresented: .constant(true))
}
