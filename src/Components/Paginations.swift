//
//  Paginations.swift
//  ios
//
//  Created by Teodor Calin on 13/11/24.
//

import SwiftUI

enum PaginationType {
    case onboarding, quiz
}

struct Paginations: View {
    var totalCount: Int
    @Binding var currentIndex: Int
    var paginationType: PaginationType
    var invertedColor: Bool = false
    
    var body: some View {
        switch paginationType {
        case .onboarding:
            OnboardingPagination(totalCount: totalCount, currentIndex: $currentIndex, invertedColor: invertedColor)
        case .quiz:
            QuizPagination(totalCount: totalCount, currentIndex: $currentIndex, invertedColor: invertedColor)
        }
    }
}

fileprivate struct QuizPagination: View {
    var totalCount: Int
    @Binding var currentIndex: Int
    var invertedColor: Bool = false
    
    private var progressWidth: CGFloat {
        guard totalCount > 0 else { return 0 }
        let screenWidth = UIScreen.main.bounds.width - 32 // Account for padding
        // Progress is based on completed questions (currentIndex - 1)
        let answeredQuestions = max(0, currentIndex - 1)
        return (CGFloat(answeredQuestions) / CGFloat(totalCount)) * screenWidth
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 8)
                .foregroundStyle(Color(hex: "#D9D9D9"))
            
            if totalCount > 0 {
                Capsule()
                    .frame(width: progressWidth, height: 8)
                    .foregroundStyle(Color(hex: "#FD6854"))
                
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .foregroundStyle(.yellow)
                    .overlay(
                        Text("\(currentIndex)")
                            .foregroundStyle(.black)
                            .font(.caption)
                            .fontWeight(.bold)
                    )
                    .offset(x: progressWidth - 19) // Center the star on the progress bar
            }
        }
        .padding(.horizontal)
    }
}

fileprivate struct OnboardingPagination: View {
    var totalCount: Int
    @Binding var currentIndex: Int
    var invertedColor: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...totalCount, id: \.self) { index in
                if index == currentIndex {
                    OnboardingActiveCell(color: invertedColor ? .white : Color.earnitAccent)
                } else {
                    OnboardingInactiveCell()
                }
            }
        }
    }
}

fileprivate struct OnboardingActiveCell: View {
    var color: Color
    var body: some View {
        Capsule()
            .frame(width: 33, height: 8)
            .foregroundStyle(color)
    }
}

fileprivate struct OnboardingInactiveCell: View {
    var body: some View {
        Capsule()
            .frame(width: 8, height: 8)
            .foregroundStyle(Color(hex: "#D9D9D9"))
    }
}

fileprivate struct testView : View {
    @State var currentIndexOnboarding = 0
    @State var currentIndexQuiz = 0
    
    var body: some View{
        VStack(spacing: 100) {
            Paginations(totalCount: 8, currentIndex: $currentIndexOnboarding, paginationType: .onboarding)
            Paginations(totalCount: 8, currentIndex: $currentIndexQuiz, paginationType: .quiz)
            
            Button("Next") {
                if currentIndexOnboarding < 8 {
                    currentIndexOnboarding += 1
                } else {
                    currentIndexOnboarding = 1
                }
                
                if currentIndexQuiz < 8 {
                    currentIndexQuiz += 1
                } else {
                    currentIndexQuiz = 1
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    testView()
}
