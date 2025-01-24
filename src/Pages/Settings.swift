//
//  Settings.swift
//  ios
//
//  Created by Teodor Calin on 23/11/24.
//

import SwiftUI
import FirebaseAnalytics

struct Settings: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var presentingConfirmationDialog = false
    @State private var notificationsEnabled = false
    @State private var screenTimeEnabled = true

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    // Profile Section
                    VStack(alignment: .center) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding(.top)
                        
                        Text(viewModel.userName)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(viewModel.userEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    
                    // Settings List
                    List {
                        Section(header: Text("App Settings")) {
                            NavigationLink(destination: Text("Profile Settings")) {
                                ListRow(image: Image(systemName: "person.fill"), 
                                      text: "Profile", 
                                      content: { EmptyView() }(), 
                                      color: .blue)
                            }
                            
                            Toggle(isOn: $notificationsEnabled) {
                                ListRow(image: Image(systemName: "bell.fill"), 
                                      text: "Notifications", 
                                      content: { EmptyView() }(), 
                                      color: .red)
                            }
                            
                            Toggle(isOn: $screenTimeEnabled) {
                                ListRow(image: Image(systemName: "timer"), 
                                      text: "Screen Time", 
                                      content: { EmptyView() }(), 
                                      color: .purple)
                            }
                        }
                        
                        Section(header: Text("Account")) {
                            Button(action: signOut) {
                                HStack {
                                    Text("Sign Out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                            
                            Button(action: { presentingConfirmationDialog.toggle() }) {
                                HStack {
                                    Text("Delete Account")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                CustomButton(buttonType: .arrow, arrowDirection: .left, variant: .small)
            })
            .navigationBarTitle("Settings", displayMode: .inline)
            .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                              isPresented: $presentingConfirmationDialog,
                              titleVisibility: .visible) {
                Button("Delete Account", role: .destructive, action: deleteAccount)
                Button("Cancel", role: .cancel, action: {})
            }
        }
    }

    private func signOut() {
        viewModel.signOut()
        dismiss()
    }

    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
}

#Preview {
    Settings()
        .environmentObject(AuthenticationViewModel())
}