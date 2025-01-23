//
//  Login.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Splash: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showingLogin = false
    @State private var showingRegister = false
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                NavigationLink(destination: Register(rootIsPresented: .constant(false)), isActive: $showingRegister) {
                    EmptyView()
                }
                
                NavigationLink(destination: Login(), isActive: $showingLogin) {
                    EmptyView()
                }
                
                Button(action: {
                    print("Get Started tapped")
                    viewModel.flow = .register
                    viewModel.reset()
                    showingRegister = true
                }) {
                    CustomButton(buttonType: .full, text: "Get Started")
                }
                .padding(.horizontal)
                
                Button(action: {
                    print("Already Have an Account tapped")
                    viewModel.flow = .login
                    viewModel.reset()
                    showingLogin = true
                }) {
                    CustomButton(buttonType: .outline, text: "Already Have an Account")
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    Splash()
        .environmentObject(AuthenticationViewModel())
}
