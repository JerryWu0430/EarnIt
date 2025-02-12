//
//  Onboarding.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_1: View {
    @State var name: String = ""
    @Binding var currentStep: Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.earnitAccent.opacity(0.2))
                VStack{
                    Spacer()
                    Image("o1")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("What is your name?")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            
            CustomTextInput(text: $name, label: "Name")
                .padding([.horizontal, .top])
            
            Spacer()
            
            HStack{
                Paginations(totalCount: 5, currentIndex: .constant(1), paginationType: .onboarding)
                Spacer()
                Button(action: {
                    if !name.isEmpty {
                        viewModel.updateUserName(name)
                        currentStep += 1
                    }
                }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right)
                }
            }.padding(.bottom).padding(.horizontal)
        }
    }
}

#Preview {
    Onboarding_1(currentStep: .constant(1))
        .environmentObject(AuthenticationViewModel())
}
