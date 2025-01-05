//
//  Selectors.swift
//  ios
//
//  Created by Teodor Calin on 12/11/24.
//

import SwiftUI
import LaTeXSwiftUI


//TODO: make transparent, add stroke
struct SubjectSelector : View {
    var subjectName : String
    var subjectImage : String
    @Binding var selected: Bool
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(selected ? Color.earnitAccent : .gray)
                .cornerRadius(5)
                .frame(width: 104, height: 95)
            Rectangle()
                .foregroundColor(selected ? Color.earnitAccent : .white)
                .cornerRadius(4)
                .frame(width: 102, height: 93)
            VStack{
                Image(systemName: subjectImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(selected ? .white : .gray)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32, alignment: .center)
                Text(subjectName)
                    .fontWeight(.semibold)
                    .padding(.top,2)
                    .foregroundStyle(selected ? .white : .gray)
            }
        }
    }
}

struct SubscriptionSelector : View {
    @Binding var selected : Bool
    
    var header: String
    var subheader: String
    
    var pillPresent: Bool = false
    var pillText: String?
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: selected ? 2 : 0)
                .frame(height: 82)
            Rectangle()
                .foregroundStyle(Color.black.opacity(0.2))
                .frame(height: 82)
                .cornerRadius(8)
                .padding(.horizontal, 2)
            if(pillPresent){
                HStack{
                    Spacer()
                    Capsule()
                        .frame(width: 80, height: 22)
                        .overlay(content: {
                            Text(pillText!)
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        })
                }.padding(.trailing)
                 .padding(.bottom,30)
            }
            VStack{
                HStack{
                    Text(header)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack{
                    Text(subheader)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                Spacer()
            }.padding(.leading)
             .padding(.top)
             .padding(.top)
        }
    }
}

enum QuestionState {
    case unanswered, correct, incorrect
}

enum QuestionType {
    case latex, text, image
}

struct QuestionSelector : View {
    @Binding var questionState: QuestionState
    var questionType: QuestionType
    var questionIndex: String
    var questionContent: String
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                HStack(alignment: .center){
                    ZStack{
                        Circle()
                            .foregroundStyle(QuestionStateToColorText())
                            .frame(width: 43, height: 43)
                        Circle()
                            .foregroundStyle(QuestionStateToColorIndex())
                            .frame(width: 40, height: 40)
                            .overlay(content: {
                                Text(questionIndex).foregroundStyle(QuestionStateToColorText()).fontWeight(.bold)
                            })
                    }.padding(.leading,10)
                     .padding(.trailing)
                    
                    
                    switch questionType {
                    case .latex:
                        VStack{
                            Spacer()
                            LaTeX(questionContent) //TODO: Fix alignment
                                .foregroundStyle(QuestionStateToColorText())
                            Spacer()
                        }
                    case .text:
                        Text(questionContent)
                            .fontWeight(.bold)
                            .foregroundStyle(QuestionStateToColorText())
                    case .image:
                        Image(questionContent)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    Spacer()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(QuestionStateToColorBg())
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        }
    }
    
    func QuestionStateToColorBg() -> Color{
        switch self.questionState {
        case .unanswered:
            return Color(hex: "#FFE5CF")
        case .correct:
            return Color(hex: "#67CE67")
        case .incorrect:
            return Color(hex: "#EC2326")
        }
    }

    func QuestionStateToColorText() -> Color{
        switch self.questionState {
        case .unanswered:
            return Color(hex: "#000000")
        case .correct:
            return Color(hex: "#FFFFFF")
        case .incorrect:
            return Color(hex: "#FFFFFF")
        }
    }
    
    func QuestionStateToColorIndex() -> Color{
        switch self.questionState {
        case .unanswered:
            return Color(hex: "#FEA050")
        case .correct:
            return Color(hex: "#166016")
        case .incorrect:
            return Color(hex: "#7E0304")
        }
    }
}

#Preview {
    ScrollView{
        VStack{
            HStack(spacing: 5){
                SubjectSelector(subjectName: "Geography", subjectImage: "globe.americas.fill", selected: .constant(false))
                SubjectSelector(subjectName: "Geography", subjectImage: "globe.americas.fill", selected: .constant(true))
                SubjectSelector(subjectName: "Subject", subjectImage: "gearshape.fill", selected: .constant(true))
            }
            ZStack{
                Rectangle()
                    .foregroundStyle(Color.earnitAccent)
                
                VStack{
                    SubscriptionSelector(selected: .constant(true), header: "Annual", subheader: "First 30 days free - Then £29.99/Year")
                        .padding(.horizontal)
                    SubscriptionSelector(selected: .constant(false), header: "Monthly", subheader: "First 7 days free - Then £7.99/Year")
                        .padding(.horizontal)
                    SubscriptionSelector(selected: .constant(false), header: "Monthly", subheader: "First 7 days free - Then £7.99/Year", pillPresent: true, pillText: "Best Value")
                        .padding(.horizontal)
                    SubscriptionSelector(selected: .constant(true), header: "Monthly", subheader: "First 7 days free - Then £7.99/Year", pillPresent: true, pillText: "Best Value")
                        .padding(.horizontal)
                }
            }.frame(height: 400)
            
            QuestionSelector(questionState: .constant(.unanswered), questionType: .text, questionIndex: "A", questionContent: "a+b")
                .padding()
            QuestionSelector(questionState: .constant(.correct), questionType: .text, questionIndex: "A", questionContent: "a+b")
                .padding()
            QuestionSelector(questionState: .constant(.incorrect), questionType: .text, questionIndex: "A", questionContent: "a+b")
                .padding()
        }
    }
}
