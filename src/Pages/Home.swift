//
//  Home.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showingSettings = false
    @State private var selectedSubject = "Geography"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("👋 Hello,")
                        Text(viewModel.userName)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: Settings()) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "#FD6854"))
                    }
                }.padding()
                
                HStack {
                    HomeRow(halved: true, header: "3 min", footer: "Time Left", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#FD6855"), backgroundColor: Color(hex: "#FD6855").opacity(0.3))
                    HomeRow(halved: true, header: "3 min", footer: "Time Left", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#00B2FF"), backgroundColor: Color(hex: "#00B2FF").opacity(0.3))
                }.padding(.horizontal)
                
                HomeRow(header: "3 min", footer: "Total Screen Time", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#FF8000"), backgroundColor: Color(hex: "#FF8000").opacity(0.3))
                    .padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Select Subject")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Choose your relevant subject to start the quiz")
                            .font(.caption)
                    }
                    Spacer()
                }.padding()
                
                HStack(spacing: 10) {
                    Spacer()
                    SubjectSelector(subjectName: "Geography", subjectImage: "globe.americas.fill", selected: .constant(selectedSubject == "Geography"))
                        .onTapGesture { selectedSubject = "Geography" }
                    SubjectSelector(subjectName: "Math", subjectImage: "function", selected: .constant(selectedSubject == "Math"))
                        .onTapGesture { selectedSubject = "Math" }
                    SubjectSelector(subjectName: "Science", subjectImage: "atom", selected: .constant(selectedSubject == "Science"))
                        .onTapGesture { selectedSubject = "Science" }
                    Spacer()
                }
                .padding(.horizontal)
                
                Image("home")
                
                Button(action: {
                    // Start quiz action
                }) {
                    CustomButton(buttonType: .full, text: "Start Quiz")
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    Home()
        .environmentObject(AuthenticationViewModel())
}
