//
//  ContentView.swift
//  Questionnaire
//
//  Created by David Mikhailov on 01/06/2023.
//

import SwiftUI

struct QuestionnaireView: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    
    var body: some View {
        VStack {
            List {
                Section() {
                    Text(Constants.titleQuestionnaire)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(Constants.subtitleQuestionnaire)
                        .font(.system(size: 15))
                    Text(Constants.requiredText)
                        .foregroundColor(.red)
                }
                
                ForEach(viewModel.questions) { question in
                    let currentAnswer = viewModel.currentAnswers.first { $0.questionId == question.id }
                    Section() {
                        QuestionLabel(label: question.questionText, isRequired: question.required)
                        addTextAnswer(question: question, currentAnswer: currentAnswer)
                        
                        ForEach(question.answerOptions, id: \.self) { option in
                            addAnswers(option: option, question: question, currentAnswer: currentAnswer)
                        }
                        .padding(5)
                    }
                }
            }
            .background(Color(hex: Constants.backgroundColor))
            .scrollContentBackground(.hidden)
            Button(action: {
                submitForm()
            }) {
                Text(Constants.submit)
                    .padding()
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .background(Color(hex: Constants.backgroundButtonColor))
                    .cornerRadius(10)
            }
        }
        .background(Color(hex: Constants.backgroundColor))
    }
    
    private func submitForm() {
        viewModel.submit()
    }
    
    @ViewBuilder
    func addOtherTextField(_ option: String, question: QuestionModel, currentAnswer: AnswerModel.Answer?) -> some View {
        if option == "Other:" {
            TextField("Answer", text: Binding(
                get: { viewModel.currentTextAnswer },
                set: { newValue in
                    viewModel.updateAnswerForSingleChoiceQuestion(questionId: question.id, newAnswer: option, extraText: newValue)
                }
            ))
        }
    }
    
    @ViewBuilder
    func addAnswers(option: String, question: QuestionModel, currentAnswer: AnswerModel.Answer?) -> some View {
        if question.questionType == .single {
            HStack {
                RadioButton(label: option, isSelected: currentAnswer?.answer.contains { $0.contains(option) } ?? false) {
                    if option != "Other:" {
                        viewModel.currentTextAnswer = ""
                    }
                    viewModel.updateAnswerForSingleChoiceQuestion(questionId: question.id, newAnswer: option, extraText: viewModel.currentTextAnswer)
                }
                addOtherTextField(option, question: question, currentAnswer: currentAnswer)
            }
        } else {
            Checkbox(label: option, isSelected: currentAnswer?.answer.contains(option) ?? false) {
                viewModel.updateAnswerForMultipleChoiceQuestion(questionId: question.id, newAnswer: option, isSelected: !(currentAnswer?.answer.contains(option) ?? false))
            }
        }
    }
    
    @ViewBuilder
    func addTextAnswer(question: QuestionModel, currentAnswer: AnswerModel.Answer?) -> some View {
        if question.questionType == .text {
            TextField("Answer", text: Binding(
                get: {
                    currentAnswer?.answer.first ?? ""
                },
                set: { newValue in
                    viewModel.updateAnswerForTextQuestion(questionId: question.id, newAnswer: newValue)
                }
            ))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView(viewModel: QuestionnaireViewModel())
    }
}
