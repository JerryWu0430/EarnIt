//
//  Onboarding_6.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_6: View {
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
                    Image("o6")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("Allow screen time and\n notifications")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundStyle(.white)
            
            CustomButton(buttonType : .full, text: "Allow", invertedColor: true)
                .padding([.horizontal, .top])
            Spacer()
            
            HStack{
                Paginations(totalCount: 6, currentIndex: .constant(6), paginationType: .onboarding, invertedColor: true)
                Spacer()
                CustomButton(buttonType: .arrow, arrowDirection: .right, invertedColor: true)
            }.padding(.bottom).padding(.horizontal)
        }.background(Color.earnitAccent)
    }
}

#Preview {
    Onboarding_6()
}
