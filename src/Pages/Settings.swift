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

    var body: some View {
        ZStack{
                VStack{
                    HStack{
                        CustomButton(buttonType: .arrow, arrowDirection: .left, variant: .small)
                        Spacer()
                    }.padding()
                    Spacer()
                }
                VStack(alignment: .center){
                    HStack{
                        Spacer()
                        Text("Settings")
                            .font(.title)
                            .padding(.top)
                        Spacer()
                    }.padding()
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .clipped()
                                .padding(4)
                                .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                            Spacer()
                        }
                        Button(action: {}) {
                            Text("Edit")
                        }
                    }
                    Text("Jerry Wu") //change for the username
                        .font(.title)
                        .fontWeight(.bold)
                    Text(viewModel.displayName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                    
                    CustomButton(buttonType: .full, text: "Edit Details")
                        .padding()
                    
                    VStack{
                        ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                            Button(action: {
                                // Action here
                            }, label: {
                                Image(systemName: "arrow.right")
                            })
                        }(), color: Color.blue).padding(5)
                        Divider()
                        ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                            Toggle("", isOn: .constant(false))
                        }(), color: Color.blue).padding(5)
                        Divider()
                        ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                            Button(action: {
                                // Action here
                            }, label: {
                                Image(systemName: "arrow.right")
                            })
                        }(), color: Color.blue, notifications: 10).padding(5)
                        Divider()
                        ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                            Button(action: {
                                // Action here
                            }, label: {
                                Image(systemName: "arrow.right")
                            })
                        }(), color: Color.blue, notifications: 10).padding(5)
                        Divider()
                        ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                            Button(action: {
                                // Action here
                            }, label: {
                                Image(systemName: "arrow.right")
                            })
                        }(), color: Color.blue, notifications: 10).padding(5)
                        Divider()
                        Spacer()
                    }.padding()
                     .background(.white)
                     .clipShape(RoundedRectangle(cornerRadius: 10))
                     .shadow(color: .gray.opacity(0.15), radius: 10, y: 1)
                     .padding(.horizontal)

                     HStack{
                        Button(action: signOut) {
                            CustomButton(buttonType: .full, text: "Sign out")
                        }
                        .padding()

                        Button(action: { presentingConfirmationDialog.toggle() }) {
                            CustomButton(buttonType: .full, text: "Delete Account")
                        }
                        .padding()

                        .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                                            isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
                            Button("Delete Account", role: .destructive, action: deleteAccount)
                            Button("Cancel", role: .cancel, action: { })
                        }
                     }
                    
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
}
