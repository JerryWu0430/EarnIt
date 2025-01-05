//
//  Rows.swift
//  ios
//
//  Created by Teodor Calin on 13/11/24.
//

import SwiftUI

struct ListRow<Content: View>: View {
    var image: Image
    var text: String
    var content: Content?
    var color: Color
    var notifications: Int = 0
    
    var body: some View {
        HStack {
            image
                .foregroundColor(color)
                .padding(2)
                .background(color.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 5)))
            
            Text(text)
                .font(.callout)
                .padding(.leading)
            
            if notifications > 0{
                Circle()
                    .frame(width: 18, height: 18)
                    .padding(.leading,2)
                    .foregroundStyle(.gray.opacity(0.3))
                    .overlay(content: {
                        Text(String(notifications))
                            .font(.caption)
                            .padding(.leading,2)
                    })
            }
                
            Spacer()
            
            if let content = content {
                content
            }
        }
    }
}

struct ModeRow: View {
    var color: Color
    var modeName: String
    var firstHeadline: String
    var secondHeadline: String
    var firstSubheadline: String
    var secondSubheadline: String
    
    
    var body: some View {
        VStack{
            HStack{
                Text(modeName)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .padding(.top, 5)
                Spacer()
            }
                .padding(.horizontal)
            Divider()
            HStack(alignment: .center){
                Image(systemName: "gift.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(color)
                    .frame(width: 26, height: 26)
                    .padding(10)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                    .padding(.leading)
                    .padding(.bottom)
                Spacer()
                VStack(alignment: .leading, content: {
                    Text(firstHeadline)
                        .font(.headline)
                    Text(firstSubheadline)
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                }).padding(.bottom)
                Spacer()
                VStack(alignment: .leading, content: {
                    Text(secondHeadline)
                        .font(.headline)
                    Text(secondSubheadline)
                        .foregroundStyle(.gray)
                        .font(.subheadline)
                }).padding(.bottom)
                Spacer()
            }.padding(.top)
        }
         .background(.white)
         .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
         
    }
}

struct HomeRow: View {
    var halved: Bool = false
    var header: String
    var footer: String
    var image: Image
    var color: Color
    var backgroundColor: Color
    
    var body: some View {
        HStack{
            image
                .renderingMode(.template)
                .foregroundStyle(.white)
                .padding(3)
                .background(color)
                .clipShape(Circle())
                .padding(2)
                .background(.white)
                .clipShape(Circle())
            
            if(halved){
                VStack(alignment: .leading, content: {
                    Text(header)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(footer)
                        .font(.caption)
                })
                Spacer()
            }
            else{
                Text(header)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.trailing)
                Text(footer)
                    .padding()
            }
            
            Spacer()
            
            

        }
        .padding()
        .frame(height: 70)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    VStack{
        List {
            ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                Button(action: {
                    // Action here
                }, label: {
                    Image(systemName: "arrow.right")
                })
            }(), color: Color.blue)
            ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                Toggle("", isOn: .constant(false))
            }(), color: Color.blue)
            ListRow(image: Image(systemName: "gearshape.fill"), text: "Settings", content: {
                Button(action: {
                    // Action here
                }, label: {
                    Image(systemName: "arrow.right")
                })
            }(), color: Color.blue, notifications: 10)
        }.frame(height: 200)
        
        Spacer()
        
        ModeRow(color: Color.blue, modeName: "Focus Mode", firstHeadline: "25 Minutes", secondHeadline: "05 Minutes", firstSubheadline: "Learn with Focus", secondSubheadline: "Screen Time").padding()
            .shadow(radius: 5)
        
        HStack{
            HomeRow(halved: true, header: "3 min", footer: "Time Left", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#FD6855"), backgroundColor: Color(hex: "#FD6855").opacity(0.3))
            HomeRow(halved: true, header: "3 min", footer: "Time Left", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#00B2FF"), backgroundColor: Color(hex: "#00B2FF").opacity(0.3))
        }.padding(.horizontal)
        
        HomeRow(header: "3 min", footer: "Total Screen Time", image: Image(systemName: "gearshape.fill"), color: Color(hex: "#FF8000"), backgroundColor:  Color(hex: "#FF8000").opacity(0.3))
            .padding(.horizontal)
        
        Spacer()
    }
}
