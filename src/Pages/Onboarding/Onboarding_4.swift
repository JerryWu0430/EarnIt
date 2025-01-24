//
//  Onboarding_2.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_4: View {
    @State var name: String = ""
    @Binding var currentStep: Int
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.black.opacity(0.2))
                VStack{
                    Spacer()
                    Image("o4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("Select Your Apps\n")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundStyle(.white)
            
            Button(action: { /* Add app selection logic */ }) {
                CustomButton(buttonType: .full, text: "Add Apps", invertedColor: true)
            }
            .padding([.horizontal, .top])
            Spacer()
            
            HStack{
                Paginations(totalCount: 5, currentIndex: .constant(3), paginationType: .onboarding, invertedColor: true)
                Spacer()
                Button(action: { currentStep += 1 }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right, invertedColor: true)
                }
            }.padding(.bottom).padding(.horizontal)
        }.background(Color.earnitAccent)
    }
}

#Preview {
    Onboarding_4(currentStep: .constant(3))
}
