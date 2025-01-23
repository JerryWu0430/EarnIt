//
//  Onboarding_5.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_5: View {
    @State var name: String = ""
    @Binding var currentStep: Int
    
    var body: some View {
        VStack{
            Text("Select your earn mode")
                .font(.headline)
                .padding(.bottom, 30)
            
            
            ModeRow(color: Color.earnitAccent, modeName: "Focus Mode", firstHeadline: "25 Minutes", secondHeadline: "05 Minutes", firstSubheadline: "Learn with focus", secondSubheadline: "Screen Time").shadow(color: .gray.opacity(0.2), radius: 10).padding(.horizontal)
            ModeRow(color: Color.green, modeName: "Balanced Mode", firstHeadline: "25 Minutes", secondHeadline: "05 Minutes", firstSubheadline: "Learn with focus", secondSubheadline: "Screen Time").shadow(color: .gray.opacity(0.2), radius: 10).padding(.horizontal)
            ModeRow(color: Color.purple, modeName: "Reward Mode", firstHeadline: "25 Minutes", secondHeadline: "05 Minutes", firstSubheadline: "Learn with focus", secondSubheadline: "Screen Time").shadow(color: .gray.opacity(0.2), radius: 10).padding(.horizontal)
            
            Spacer()
            
            HStack{
                Paginations(totalCount: 5, currentIndex: .constant(4), paginationType: .onboarding)
                Spacer()
                Button(action: { currentStep += 1 }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right)
                }
            }.padding(.bottom).padding(.horizontal)
        }
    }
}

#Preview {
    Onboarding_5(currentStep: .constant(4))
}
