//
//  Premium.swift
//  ios
//
//  Created by Teodor Calin on 23/11/24.
//

import SwiftUI

struct Premium: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("Get Premium")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text("you access to all the quizzes for all subjects")
                    .font(.footnote)
                    .foregroundStyle(.white)
                Image("bro")
                
                ZStack{
                    Rectangle()
                        .foregroundStyle(Color.earnitAccent)
                    
                    VStack{
                        SubscriptionSelector(selected: .constant(true), header: "Annual", subheader: "First 30 days free - Then £29.99/Year", pillPresent: true, pillText: "Best Value")
                            .padding(.horizontal)
                        SubscriptionSelector(selected: .constant(false), header: "Monthly", subheader: "First 7 days free - Then £7.99/Year")
                            .padding(.horizontal)
                    }
                }.frame(height: 200)
                
                CustomButton(buttonType: .outline, text: "Start 7-day free trial", invertedColor: true)
                    .padding(.horizontal)
                
                CustomButton(buttonType: .full, text: "Start 7-day free trial", invertedColor: true)
                    .padding(.horizontal)
                
                
                Text("By placing this order, you agree to the **Terms of Service** and **Privacy Policy**. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.")
                    .padding()
                    .font(.caption)
                    .foregroundStyle(.white)
                
                
                
                Spacer()
            }
        }
        .background(Color(hex: "#FD6855"))
    }
}

#Preview {
    Premium()
}
