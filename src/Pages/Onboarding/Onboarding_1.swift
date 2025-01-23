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
                CustomButton(buttonType: .arrow, arrowDirection: .right) {
                    currentStep += 1
                }
            }.padding(.bottom).padding(.horizontal)
        }
    }
}

#Preview {
    Onboarding_1(currentStep: .constant(1))
}
