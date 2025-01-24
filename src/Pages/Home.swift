//
//  Home.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject private var timeManager = TimeManager()
    @State private var showingSettings = false
    @State private var selectedSubject = "Maths"  // Default to Maths
    
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
                    HomeRow(halved: true, header: timeManager.formatTime(timeManager.timeLeft), footer: "Time Left", image: Image(systemName: "clock.fill"), color: Color(hex: "#FD6855"), backgroundColor: Color(hex: "#FD6855").opacity(0.3))
                    HomeRow(halved: true, header: timeManager.formatTime(timeManager.timeEarned), footer: "Time Earned", image: Image(systemName: "star.fill"), color: Color(hex: "#00B2FF"), backgroundColor: Color(hex: "#00B2FF").opacity(0.3))
                }.padding(.horizontal)
                
                HomeRow(header: timeManager.formatTime(timeManager.totalScreenTime), footer: "Total Screen Time", image: Image(systemName: "hourglass.circle.fill"), color: Color(hex: "#FF8000"), backgroundColor: Color(hex: "#FF8000").opacity(0.3))
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        SubjectSelector(subjectName: "Maths", subjectImage: "function", selected: .constant(selectedSubject == "Maths"))
                            .onTapGesture { selectedSubject = "Maths" }
                        SubjectSelector(subjectName: "Biology", subjectImage: "leaf.fill", selected: .constant(selectedSubject == "Biology"))
                            .onTapGesture { selectedSubject = "Biology" }
                        SubjectSelector(subjectName: "Physics", subjectImage: "atom", selected: .constant(selectedSubject == "Physics"))
                            .onTapGesture { selectedSubject = "Physics" }
                        SubjectSelector(subjectName: "Chemistry", subjectImage: "flask.fill", selected: .constant(selectedSubject == "Chemistry"))
                            .onTapGesture { selectedSubject = "Chemistry" }
                    }
                }
                .padding(.horizontal)
                
                Image("home")
                
                NavigationLink(destination: Quiz(subject: selectedSubject).environmentObject(timeManager)) {
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
