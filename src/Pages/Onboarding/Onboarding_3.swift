//
//  Onboarding.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI

struct Onboarding_3: View {
    @State private var selectedSubjects: [String] = []
    @Binding var currentStep: Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    private let subjects = ["Maths", "Biology", "Physics", "Chemistry"]
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 302, height: 302)
                    .foregroundStyle(Color.earnitAccent.opacity(0.2))
                VStack {
                    Spacer()
                    Image("o3")
                }.frame(width: 302, height: 302)
            }.padding(.top, 100)
            
            Text("What subjects do you want \n to focus on?")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            
            VStack(spacing: 10) {
                ForEach(subjects, id: \.self) { subject in
                    Button(action: {
                        if selectedSubjects.contains(subject) {
                            selectedSubjects.removeAll { $0 == subject }
                        } else {
                            selectedSubjects.append(subject)
                        }
                    }) {
                        HStack {
                            Text(subject)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedSubjects.contains(subject) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.earnitAccent)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                }
            }
            .padding([.horizontal, .top])
            
            Spacer()
            
            HStack {
                Paginations(totalCount: 5, currentIndex: .constant(2), paginationType: .onboarding)
                Spacer()
                Button(action: {
                    if !selectedSubjects.isEmpty {
                        viewModel.updateUserProfile(subjects: selectedSubjects)
                        currentStep += 1
                    }
                }) {
                    CustomButton(buttonType: .arrow, arrowDirection: .right)
                }
                .disabled(selectedSubjects.isEmpty)
            }.padding(.bottom).padding(.horizontal)
        }
        .onAppear {
            selectedSubjects = viewModel.selectedSubjects
        }
    }
}

#Preview {
    Onboarding_3(currentStep: .constant(2))
        .environmentObject(AuthenticationViewModel())
}
