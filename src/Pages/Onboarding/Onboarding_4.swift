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
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showingAppSelection = false
    
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
            
            if !viewModel.selectedApps.isEmpty {
                ForEach(viewModel.selectedApps, id: \.self) { app in
                    Text(app)
                        .foregroundStyle(.white)
                }
            }
            
            Button(action: {
                showingAppSelection = true
            }) {
                CustomButton(buttonType: .full, text: "Add Apps", invertedColor: true)
            }
            .padding([.horizontal, .top])
            .sheet(isPresented: $showingAppSelection) {
                // Temporary app selection
                List(["Instagram", "TikTok", "YouTube", "Facebook", "Twitter"], id: \.self) { app in
                    Button(action: {
                        var apps = viewModel.selectedApps
                        if !apps.contains(app) {
                            apps.append(app)
                            viewModel.updateUserProfile(apps: apps)
                        }
                    }) {
                        HStack {
                            Text(app)
                            Spacer()
                            if viewModel.selectedApps.contains(app) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
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
        .environmentObject(AuthenticationViewModel())
}
