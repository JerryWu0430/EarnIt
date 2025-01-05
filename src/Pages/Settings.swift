//
//  Settings.swift
//  ios
//
//  Created by Teodor Calin on 23/11/24.
//

import SwiftUI

struct Settings: View {
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
                    Image("profile")
                        .background(.green)
                        .clipShape(Circle())
                    Text("Alex Jones")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("email@example.com")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    
                    CustomButton(buttonType: .full, text: "Edit Details")
                        .padding(.horizontal).padding(.horizontal)
                    
                    HStack{
                        Text("Settings")
                            .foregroundStyle(.gray)
                            .font(.callout)
                        Spacer()
                    }.padding()
                    
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
                    
                    CustomButton(buttonType: .full, text: "Delete Account")
                        .padding()
                    
                }
                
        }
    }
}

#Preview {
    Settings()
}
