//
//  Quiz.swift
//  ios
//
//  Created by Teodor Calin on 24/11/24.
//

import SwiftUI
import Foundation


struct Quiz: View {
    let subject: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timeManager: TimeManager
    @State private var answered: Bool = false
    @State private var currentQuestion: Question? = nil
    @State private var selectedAnswer: String? = nil
    @State private var isCorrect: Bool? = nil
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex: Int = 0
    @State private var correctAnswers: Int = 0
    @State private var timeRemaining: Int = 300 
    @State private var timer: Timer? = nil
    @State private var showingResult = false
    
    var body: some View {
        VStack {
            if showingResult {
                Result(correctAnswers: correctAnswers, 
                      totalQuestions: 10, 
                      earnedMinutes: timeManager.calculateEarnedMinutes(correctAnswers: correctAnswers))
            } else if let question = currentQuestion {
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: { dismiss() }) {
                            NavigationButton(image: "xmark.circle.fill")
                        }
                        Text(question.subject)
                            .font(.title)
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 30)
                            .overlay {
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.earnitAccent)
                                    Text(timeString(from: timeRemaining))
                                        .font(.callout)
                                }
                            }
                            .shadow(color: .gray.opacity(0.15), radius: 10, y: 1)
                    }
                    .padding(.horizontal)
                    
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.white)
                            .shadow(color: .gray.opacity(0.4), radius: 10, y: 1)
                            .frame(height: 52)
                        Paginations(totalCount: questions.count, currentIndex: .constant(currentQuestionIndex + 1), paginationType: .quiz)
                    }
                    .padding(.horizontal)
                    
                    GeometryReader { geometry in
                        Text(question.question)
                            .font(.system(size: calculateFontSize(for: question.question, in: geometry.size.width)))
                            .padding()
                    }
                    
                    ForEach(question.options.indices, id: \.self) { index in
                        QuestionSelector(
                            questionState: .constant(getQuestionState(for: question.options[index])),
                            questionType: .text,
                            questionIndex: String(UnicodeScalar(65 + index)!),
                            questionContent: question.options[index]
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .onTapGesture {
                            if !answered {
                                selectedAnswer = question.options[index]
                                validateAnswer()
                                answered = true
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        moveToNextQuestion()
                    }, label: {
                        CustomButton(buttonType: .full, text: currentQuestionIndex < 9 ? "Next" : "Finish")
                    })
                    .padding()
                    .disabled(!answered)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadQuestions()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                showingResult = true
            }
        }
    }
    
    func moveToNextQuestion() {
        if currentQuestionIndex < 9 {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
            selectedAnswer = nil
            isCorrect = nil
            answered = false
        } else {
            timer?.invalidate()
            showingResult = true
        }
    }
    
    func getQuestionState(for option: String) -> QuestionState {
        if let selectedAnswer = selectedAnswer {
            if option == selectedAnswer {
                return isCorrect == true ? .correct : .incorrect
            } else if option == currentQuestion?.correct_answer {
                return .correct
            }
        }
        return .unanswered
    }
    
    func calculateFontSize(for text: String, in width: CGFloat) -> CGFloat {
        let baseFontSize: CGFloat = 24
        let maxWidth: CGFloat = width - 40 // Adjust for padding
        let textWidth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: baseFontSize)]).width
        
        if textWidth > maxWidth {
            let scaleFactor = maxWidth / textWidth
            return baseFontSize * scaleFactor
        } else {
            return baseFontSize
        }
    }
    
    func loadQuestions() {
        let fileName: String
        switch subject.lowercased() {
        case "maths":
            fileName = "mathQs"
        case "biology":
            fileName = "biologyQs"
        case "physics":
            fileName = "physicsQs"
        case "chemistry":
            fileName = "chemistryQs"
        default:
            fileName = "mathQs" // Default to math if subject not recognized
        }
        
        if let jsonData = readJSONFromFile(fileName: fileName) {
            if let allQuestions = getQuestions(from: jsonData) {
                // Randomly select 10 questions
                questions = Array(allQuestions.shuffled().prefix(10))
                currentQuestion = questions.first
            } else {
                print("No questions available for \(subject)")
            }
        }
    }
    
    func validateAnswer() {
        if let question = currentQuestion, let selectedAnswer = selectedAnswer {
            let correct = selectedAnswer == question.correct_answer
            isCorrect = correct
            if correct {
                correctAnswers += 1
            }
        }
    }
    
    func getQuestions(from jsonData: Data) -> [Question]? {
        let decoder = JSONDecoder()
        do {
            let questions = try decoder.decode([Question].self, from: jsonData)
            return questions
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    func readJSONFromFile(fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return data
            } catch {
                print("Error reading JSON file: \(error)")
            }
        }
        return nil
    }
}

#Preview {
    Quiz(subject: "Maths")
}
