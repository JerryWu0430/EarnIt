//
//  Onboarding_2.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_2: View {
    //Change
    @State var name: String = ""
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.black.opacity(0.2))
                VStack{
                    Spacer()
                    Image("o2")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("How old is your child?\n")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundStyle(.white)
            
            OptionSelector(selectedOption: .constant("2-6"), options: ["2-6", "7-12", "12-16"], label: "Select an Option", whiteBackground: true)
                .padding([.horizontal, .top])
            Spacer()
            
            HStack{
                Paginations(totalCount: 6, currentIndex: .constant(2), paginationType: .onboarding, invertedColor: true)
                Spacer()
                CustomButton(buttonType: .arrow, arrowDirection: .right, invertedColor: true)
            }.padding(.bottom).padding(.horizontal)
        }.background(Color.earnitAccent)
    }
}

#Preview {
    Onboarding_2()
}
