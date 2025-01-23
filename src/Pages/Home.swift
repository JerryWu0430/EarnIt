//
//  Home.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("👋 Hello,")
                    Text("Kevin Backer")
                        .font(.title2)
                }
                
                Spacer()
                
                NavigationLink(destination: Settings()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(hex: "#FD6854"))
                }
            }.padding()
            
            HStack{
                HomeRow(halved: true, header: "3 min", footer: "Time Left", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#FD6855"), backgroundColor: Color(hex: "#FD6855").opacity(0.3))
                HomeRow(halved: true, header: "3 min", footer: "Time Left", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#00B2FF"), backgroundColor: Color(hex: "#00B2FF").opacity(0.3))
            }.padding(.horizontal)
            
            HomeRow(header: "3 min", footer: "Total Screen Time", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#FF8000"), backgroundColor:  Color(hex: "#FF8000").opacity(0.3))
                .padding(.horizontal)
            
            HStack{
                VStack(alignment: .leading){
                    Text("Select Subject")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Choose your relevant subject to start the quiz")
                        .font(.caption)
                }
                Spacer()
            }.padding()
            
            HStack(spacing: 5){
                SubjectSelector(subjectName: "Geography", subjectImage: "globe.americas.fill", selected: .constant(true))
                SubjectSelector(subjectName: "Geography", subjectImage: "globe.americas.fill", selected: .constant(false))
                SubjectSelector(subjectName: "Subject", subjectImage: "gearshape.fill", selected: .constant(false))
            }
            
            Image("home")
            
            CustomButton(buttonType: .full,text: "Start Quiz")
                .padding()
        }
    }
}

#Preview {
    Home()
}
