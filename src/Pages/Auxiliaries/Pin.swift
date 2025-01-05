//
//  Pin.swift
//  ios
//
//  Created by Teodor Calin on 23/11/24.
//

import SwiftUI

struct Pin: View {
    var sheetActive: Bool = false
    
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
                    Text("Pin Code")
                        .font(.title)
                        .padding(.top)
                    Spacer()
                }.padding()
                
                Image(systemName: "lock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 41, height: 41)
                    .padding(40)
                    .background(.gray.opacity(0.2))
                    .clipShape(Circle())
                
                Text("Enter your pin")
                    .padding()
                
                PinInput(pin: .constant(["", "", "", ""]))
                
                HStack(spacing: 30){
                    DigitButton(content: "1")
                    DigitButton(content: "2")
                    DigitButton(content: "3")
                }.padding(.bottom,15)
                HStack(spacing: 30){
                    DigitButton(content: "1")
                    DigitButton(content: "2")
                    DigitButton(content: "3")
                }.padding(.bottom,15)
                HStack(spacing: 30){
                    DigitButton(content: "1")
                    DigitButton(content: "2")
                    DigitButton(content: "3")
                }.padding(.bottom,15)
                HStack(spacing: 30){
                    DigitButton(content: "checkmark.circle.fill", isImage: true, color: .green)
                    DigitButton(content: "0")
                    DigitButton(content: "delete.left.fill", isImage: true)
                    
                }
                Text("Reset Pin Code").padding(.top)
                Spacer()
            }
            if(sheetActive){
                VStack{
                    Rectangle()
                        .ignoresSafeArea(.all)
                    
                }.foregroundStyle(.black.opacity(0.3))
                
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.white)
                        .overlay(content: {
                            VStack{
                                ZStack{
                                    Image("colors")
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.white)
                                        .frame(width: 47,height: 37)
                                }
                                Text("Reset Successfully")
                                    .fontWeight(.bold)
                                    .padding(.bottom)
                                Text("You have succesfully reset your pin")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        })
                }
            }
        }
    }
}

#Preview {
    Pin()
}
