//
//  Login.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Splash: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.presentingLoginScreenBinding) var presentingLoginScreen
    
    var body: some View {
        print("Splash view initialized")
        return VStack {
            Spacer()
            Circle()
                .frame(width: 200, height: 185)
                .foregroundStyle(Color.earnitAccent)
                .overlay(content: {
                    Image("logo")
                }).padding(.bottom)
            
            Text("EarnIt!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.earnitAccent)
            Text("Learn to Earn")
            
            Spacer()
            
            CustomButton(buttonType: .full, text: "Get Started")
                .onTapGesture {
                    print("Get Started tapped")
                    viewModel.flow = .register
                    viewModel.reset()
                    presentingLoginScreen.wrappedValue.toggle()
                }
                .padding(.horizontal)
            
            CustomButton(buttonType: .outline, text: "Already Have an Account")
                .onTapGesture {
                    print("Already Have an Account tapped")
                    viewModel.flow = .login
                    viewModel.reset()
                    presentingLoginScreen.wrappedValue.toggle()
                }
                .padding(.horizontal)
        }
    }
}

#Preview {
    Splash()
}
