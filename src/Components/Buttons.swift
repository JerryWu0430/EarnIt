//
//  Buttons.swift
//  ios
//
//  Created by Teodor Calin on 12/11/24.
//

import SwiftUI

enum CustomButtonTypes {
    case outline, full, arrow
}

enum ArrowDirection{
    case right, left, up, down
}

enum Variants{
    case small, medium, large
}

struct CustomButton: View {
    var buttonType : CustomButtonTypes
    var text: String?
    var arrowDirection: ArrowDirection?
    var invertedColor: Bool = false
    var variant: Variants = .medium
    
    
    var body: some View {
        switch buttonType {
        case .outline:
            OutlineButton(text: text!, invertedColor: invertedColor)
        case .full:
            FullButton(text: text!, invertedColor: invertedColor)
        case .arrow:
            ArrowButton(arrowDirection: arrowDirection!, invertedColor: invertedColor)
        }
    }
}

struct DigitButton: View {
    var content: String
    var isImage: Bool = false
    var color: Color?
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundStyle(color ?? .black)
                .frame(width: 63, height: 63, alignment: .center)
            Circle()
                .foregroundStyle(.white)
                .frame(width: 60, height: 60, alignment: .center)
            
            if isImage{
                Image(systemName: content)
                    .resizable()
                    .foregroundStyle(color ?? .black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28, alignment: .center)
            }
            else{
                Text(content)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .foregroundStyle(color ?? .black)
            }
        }
    }
}

enum SocialButtonTypes{
    case Google, Apple, Facebook
}

//For Social Login(could be used for others but no use case for now)
struct SocialButton: View {
    var buttonType: SocialButtonTypes
    var text: String
    var action: (() -> Void)? // Optional action closure
    
    var body: some View {
        Button(action: {
            action?() // Trigger the action when tapped
        }) {
            ZStack {
                switch buttonType {
                case .Google:
                    ZStack {
                        Rectangle()
                            .frame(height: CGFloat(50))
                            .foregroundStyle(.gray)
                            .cornerRadius(10)
                        Rectangle()
                            .frame(height: CGFloat(48))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 1)
                        HStack {
                            Spacer()
                            Text(text)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Image("Google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24, alignment: .center)
                                .padding(.trailing, 12)
                        }
                    }
                case .Apple:
                    Rectangle()
                        .frame(height: 50)
                        .foregroundStyle(.black) // Example placeholder
                case .Facebook:
                    Rectangle()
                        .frame(height: 50)
                        .foregroundStyle(.blue) // Example placeholder
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Prevent default button styling if needed
    }
}


struct NavigationButton : View {
    var image: String
    var invertedColor: Bool = false
    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 36, height: 36, alignment: .center)
                .foregroundStyle(invertedColor ? Color.earnitAccent : Color(UIColor(red: CGFloat(163/255), green: CGFloat(163/255), blue: CGFloat(163/255), alpha: 0.05)))
            Image(systemName: image)
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24, alignment: .center)
                .foregroundStyle(invertedColor ? .white : Color.earnitAccent)
        }
    }
}

fileprivate struct FullButton : View {
    var text: String
    var invertedColor : Bool

    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: CGFloat(50))
                .foregroundStyle(invertedColor ? .white : Color.earnitAccent)
                .cornerRadius(10)
            Text(text)
                .foregroundStyle(invertedColor ? Color.earnitAccent : .white)
                .fontWeight(.bold)
        }
    }
}

fileprivate struct OutlineButton : View {
    var text: String
    var invertedColor : Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: CGFloat(50))
                .foregroundStyle(invertedColor ? .white
                : Color.earnitAccent)
                .cornerRadius(10)
            Rectangle()
                .frame(height: CGFloat(46))
                .foregroundStyle(invertedColor ? Color.earnitAccent : .white)
                .cornerRadius(8)
                .padding(.horizontal,2)
            Text(text)
                .foregroundStyle(invertedColor ? .white : Color.earnitAccent)
                .fontWeight(.bold)
        }
    }
}

fileprivate struct ArrowButton : View {
    var arrowDirection: ArrowDirection
    var invertedColor : Bool
    var variant: Variants = .medium
    
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 44,height: 44, alignment: .center)
                .foregroundStyle(invertedColor ? .white : Color.earnitAccent)
            switch arrowDirection {
            case .right:
                Image(systemName: "arrow.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26, alignment: .center)
                    .foregroundStyle(invertedColor ? Color.earnitAccent : .white)
            case .left:
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26, alignment: .center)
                    .foregroundStyle(invertedColor ? Color.earnitAccent : .white)
            case .up:
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26, alignment: .center)
                    .foregroundStyle(invertedColor ? Color.earnitAccent : .white)
            case .down:
                Image(systemName: "arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26, alignment: .center)
                    .foregroundStyle(invertedColor ? Color.earnitAccent : .white)
            }
        }
    }
    
    func variantToSize() -> Double{
        if(variant == .medium){
            return 66.0
        }
        
        if(variant == .large){
            return 88.0
        }
        
        if(variant == .small){
            return 44.0
        }
        
        return 66.0
    }
}

//Button kit - component preview
#Preview {
    ScrollView{
        VStack(spacing: 10){
            HStack(spacing: 5){
                CustomButton(buttonType: .arrow, arrowDirection: .up, variant: .small)
                ZStack{
                    Rectangle()
                        .frame(width: 75, height: 75)
                        .foregroundStyle(Color.earnitAccent)
                    CustomButton(buttonType: .arrow, arrowDirection: .down, invertedColor: true)
                }
                CustomButton(buttonType: .arrow, arrowDirection: .right)
                ZStack{
                    Rectangle()
                        .frame(width: 75, height: 75)
                        .foregroundStyle(Color.earnitAccent)
                    CustomButton(buttonType: .arrow, arrowDirection: .left, invertedColor: true)
                }
                
            }
            
            CustomButton(buttonType: .full, text: "Test Full")
                .padding(.horizontal)
            CustomButton(buttonType: .outline, text: "Test Out")
                .padding(.horizontal)
            
            ZStack{
                Rectangle()
                    .foregroundColor(Color.earnitAccent)
                VStack{
                    CustomButton(buttonType: .outline, text: "Test Out Inv", invertedColor: true)
                        .padding(.horizontal)
                    CustomButton(buttonType: .full, text: "Test Full Inv", invertedColor: true)
                        .padding(.horizontal)
                }
            }.frame(height: 120)
            
            
            
            HStack{
                DigitButton(content: "1")
                DigitButton(content: "delete.left.fill", isImage: true)
                DigitButton(content: "checkmark.circle.fill", isImage: true, color: .green)
                DigitButton(content: "xmark.circle.fill", isImage: true, color: .red)
            }
            
            SocialButton(buttonType: .Google, text: "Sign up with google")
                .padding(.horizontal)
            
            HStack{
                NavigationButton(image: "gearshape.fill")
                NavigationButton(image: "gearshape.fill", invertedColor: true)
            }
        }
    }
}
