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
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }

    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                CustomButton(buttonType: .arrow, arrowDirection: .left)
                Spacer()
            }.padding(.leading)
            
            Text("Welcome!")
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
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(Color(UIColor.systemRed))
                    .padding(.horizontal)
            }
            
            HStack{
                Spacer()
                Text("Forgot Password?")
                    .font(.subheadline)
                    .foregroundStyle(Color.earnitAccent)
                    .padding(.horizontal)
            }
            
            HStack{
                Spacer()
                Text("By logging in you agree to our privacy policy and Terms and Conditions")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                Spacer()
            }.padding(.vertical)
            
            CustomButton(buttonType: .full, text: viewModel.authenticationState != .authenticating ? "Login" : "Loading...")
                .disabled(!viewModel.isValid)
                .padding([.horizontal,.bottom])
            
            HStack{
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(height:1)
                Text("or login with")
                    .foregroundStyle(.gray)
                    .font(.caption2)
                Rectangle()
                    .foregroundStyle(.gray)
                    .frame(height:1)
            }.padding(.horizontal)
            
            SocialButton(buttonType: .Google, text: "Login with google"){
                signInWithGoogle()
            }
                .padding()
            
            Spacer()
            
            HStack{
                Spacer()
                Text("Don't have an account? ")
                Button(action: { viewModel.switchFlow() }) {
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
    Login()
}
