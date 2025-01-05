//
//  Onboarding.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_3: View {
    //Change
    @State var name: String = ""
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.earnitAccent.opacity(0.2))
                VStack{
                    Spacer()
                    Image("o3")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("What subjects do you want \nyour child to focus on?")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            
            OptionSelector(selectedOption: .constant("Maths"), options: ["2-6", "7-12", "12-16"], label: "Select an Option", whiteBackground: true)
                .padding([.horizontal, .top])
            
            Spacer()
            
            HStack{
                Paginations(totalCount: 6, currentIndex: .constant(3), paginationType: .onboarding)
                Spacer()
                CustomButton(buttonType: .arrow, arrowDirection: .right)
            }.padding(.bottom).padding(.horizontal)
        }
    }
}

#Preview {
    Onboarding_3()
}
