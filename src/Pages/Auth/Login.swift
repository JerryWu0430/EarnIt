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
            
            CustomTextInput(text: .constant(""), label: "Email")
                .padding(.bottom)
            CustomTextInput(text: .constant(""), label: "Password", protected: true)
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
            
            CustomButton(buttonType: .full, text: "Login")
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
                Text("Don't have an account? **Sign Up**")
                Spacer()
            }
        }
    }
}

#Preview {
    Login()
}
