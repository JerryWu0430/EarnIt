//
//  Onboarding.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_3: View {
    @State private var selectedSubject: String = "Maths"
    @Binding var currentStep: Int
    
    private let subjects = ["Maths", "Biology", "Physics", "Chemistry"]
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.earnitAccent.opacity(0.2))
                VStack {
                    Spacer()
                    Image("o3")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("What subjects do you want \n to focus on?")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            
            OptionSelector(selectedOption: $selectedSubject, 
                         options: subjects, 
                         label: "Select a Subject", 
                         whiteBackground: true)
                .padding([.horizontal, .top])
            
            Spacer()
            
            HStack {
                Paginations(totalCount: 5, currentIndex: .constant(2), paginationType: .onboarding)
                Spacer()
                Button(action: { currentStep += 1 }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right)
                }
            }.padding(.bottom).padding(.horizontal)
        }
    }
}

#Preview {
    Onboarding_3(currentStep: .constant(2))
}
