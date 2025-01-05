//
//  Login.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Register: View {
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                CustomButton(buttonType: .arrow, arrowDirection: .left)
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
            
            CustomTextInput(text: .constant(""), label: "Name")
                .padding(.bottom)
            CustomTextInput(text: .constant(""), label: "Email")
                .padding(.bottom)
            CustomTextInput(text: .constant(""), label: "Password", protected: true)

            HStack{
                Spacer()
                Text("Accept sign up with our privacy policy and Terms and Conditions")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                Spacer()
            }.padding(.vertical)
            
            CustomButton(buttonType: .full, text: "Sign Up")
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
            
            SocialButton(buttonType: .Google, text: "Sign up with google")
                .padding()
            
            Spacer()
            
            HStack{
                Spacer()
                Text("Have an account already? **Sign In**")
                Spacer()
            }
        }
    }
}

#Preview {
    Register()
}
