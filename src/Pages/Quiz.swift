//
//  Quiz.swift
//  ios
//
//  Created by Teodor Calin on 24/11/24.
//

import SwiftUI
import Foundation


struct Quiz: View {
    @State private var answered: Bool = false
    @State private var currentQuestion: Question? = nil
    @State private var selectedAnswer: String? = nil
    @State private var isCorrect: Bool? = nil
    
    var body: some View {
        VStack {
            if let question = currentQuestion {
                VStack(alignment: .leading) {
                    HStack {
                        NavigationButton(image: "xmark.circle.fill")
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
                                    Text("4:55")
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
                        Paginations(totalCount: 0, currentIndex: .constant(1), paginationType: .quiz)
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
                        loadNewQuestion()
                    }, label: {
                        CustomButton(buttonType: .full, text: "Next")
                    })
                    .padding()
                }
            } else {
                VStack {
                    Button(action: loadNewQuestion) {
                        Text("New Question")
                    }
                }
            }
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
    
    func loadNewQuestion() {
        if let jsonData = readJSONFromFile(fileName: "year1_randomQs") {
            if let questions = getQuestions(from: jsonData) {
                currentQuestion = pickRandomQuestion(from: questions)
                selectedAnswer = nil
                isCorrect = nil
                answered = false
            } else {
                print("No questions available.")
            }
        }
    }
    
    func validateAnswer() {
        if let question = currentQuestion, let selectedAnswer = selectedAnswer {
            isCorrect = (selectedAnswer == question.correct_answer)
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

    func pickRandomQuestion(from questions: [Question]) -> Question? {
        return questions.randomElement()
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
    Quiz()
}
