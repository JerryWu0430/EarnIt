//
//  Onboarding_6.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_6: View {
    @State var name: String = ""
    @Binding var currentStep: Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.black.opacity(0.2))
                VStack{
                    Spacer()
                    Image("o6")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("Allow screen time and\n notifications")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundStyle(.white)
            
            Button(action: {
                Task {
                    // Request notification permission
                    let granted = await viewModel.requestNotificationPermission()
                    // Enable screen time regardless of notification permission
                    viewModel.updateUserProfile(screenTime: true)
                    // Move to next step
                    currentStep += 1
                }
            }) {
                CustomButton(buttonType: .full, text: "Allow", invertedColor: true)
            }
            .padding([.horizontal, .top])
            
            Button(action: {
                // Skip permissions but still move forward
                currentStep += 1
            }) {
                Text("Skip")
                    .foregroundColor(.white)
                    .padding(.top)
            }
            
            Spacer()
            
            HStack{
                Paginations(totalCount: 5, currentIndex: .constant(5), paginationType: .onboarding, invertedColor: true)
                Spacer()
                Button(action: { currentStep += 1 }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right, invertedColor: true)
                }
            }.padding(.bottom).padding(.horizontal)
        }.background(Color.earnitAccent)
    }
}

#Preview {
    Onboarding_6(currentStep: .constant(5))
        .environmentObject(AuthenticationViewModel())
}
