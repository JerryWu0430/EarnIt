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
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var selectedMode: String = "Focus Mode"
    
    var body: some View {
        VStack{
            Text("Select your earn mode")
                .font(.headline)
                .padding(.bottom, 30)
            
            Button(action: { 
                selectedMode = "Focus Mode"
                viewModel.updateUserProfile(mode: selectedMode)
            }) {
                ModeRow(color: Color.earnitAccent, modeName: "Focus Mode", firstHeadline: "25 Minutes", secondHeadline: "05 Minutes", firstSubheadline: "Learn with focus", secondSubheadline: "Screen Time")
                    .shadow(color: .gray.opacity(0.2), radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedMode == "Focus Mode" ? Color.earnitAccent : Color.clear, lineWidth: 2)
                    )
            }.padding(.horizontal)
            
            Button(action: { 
                selectedMode = "Balanced Mode"
                viewModel.updateUserProfile(mode: selectedMode)
            }) {
                ModeRow(color: Color.green, modeName: "Balanced Mode", firstHeadline: "25 Minutes", secondHeadline: "25 Minutes", firstSubheadline: "Learn with focus", secondSubheadline: "Screen Time")
                    .shadow(color: .gray.opacity(0.2), radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedMode == "Balanced Mode" ? Color.green : Color.clear, lineWidth: 2)
                    )
            }.padding(.horizontal)
            
            Button(action: { 
                selectedMode = "Reward Mode"
                viewModel.updateUserProfile(mode: selectedMode)
            }) {
                ModeRow(color: Color.purple, modeName: "Reward Mode", firstHeadline: "10 Minutes", secondHeadline: "50 Minutes", firstSubheadline: "Learn with focus", secondSubheadline: "Screen Time")
                    .shadow(color: .gray.opacity(0.2), radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedMode == "Reward Mode" ? Color.purple : Color.clear, lineWidth: 2)
                    )
            }.padding(.horizontal)
            
            Spacer()
            
            HStack{
                Paginations(totalCount: 5, currentIndex: .constant(4), paginationType: .onboarding)
                Spacer()
                Button(action: { currentStep += 1 }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right)
                }
            }.padding(.bottom).padding(.horizontal)
        }
        .onAppear {
            selectedMode = viewModel.selectedMode
        }
    }
}

#Preview {
    Onboarding_5(currentStep: .constant(4))
        .environmentObject(AuthenticationViewModel())
}
