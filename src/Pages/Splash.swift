//
//  Login.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Splash: View {
    var body: some View {
        VStack{
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
                .padding(.horizontal)
            CustomButton(buttonType: .outline, text: "Already Have an Account")
                .padding(.horizontal)
        }
    }
}

#Preview {
    Splash()
}
