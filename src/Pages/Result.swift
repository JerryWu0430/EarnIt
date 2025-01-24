import SwiftUI

struct Result: View {
    let correctAnswers: Int
    let totalQuestions: Int
    let earnedMinutes: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Confetti effect with balloons
            ZStack {
                ForEach(0..<20) { _ in
                    Circle()
                        .fill(Color(hex: "#FD6854").opacity(0.3))
                        .frame(width: 10, height: 10)
                        .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -200...50))
                }
                
                // Balloons
                Image(systemName: "balloon.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(Color(hex: "#FD6854"))
                    .offset(x: -100, y: -50)
                
                Image(systemName: "balloon.fill")
                    .resizable()
                    .frame(width: 40, height: 50)
                    .foregroundColor(Color(hex: "#FD6854"))
                    .offset(x: 100, y: -50)
            }
            
            // Score
            Text("\(correctAnswers)/\(totalQuestions)")
                .font(.system(size: 60))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#FD6854"))
                .padding(.top, 50)
            
            Text("\(earnedMinutes) +")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Congratulation you earned \(earnedMinutes) more\nminutes of screen time. Now your\nupdated screen time is \(7) minutes")
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            
            Spacer()
            
            // Action buttons
            Button(action: {
                // Navigate to new quiz
            }) {
                CustomButton(buttonType: .outline, text: "Play More")
            }
            .padding(.horizontal)
            
            Button(action: {
                // Navigate back to home
                dismiss()
            }) {
                CustomButton(buttonType: .full, text: "Back Home")
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    Result(correctAnswers: 5, totalQuestions: 10, earnedMinutes: 5)
} 