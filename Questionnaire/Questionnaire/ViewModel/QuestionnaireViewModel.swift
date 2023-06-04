//
//  QuestionnaireViewModel.swift
//  Questionnaire
//
//  Created by David Mikhailov on 01/06/2023.
//

import Foundation
import Dependency

class QuestionnaireViewModel: ObservableObject {
    @Published var questions: [QuestionModel] = []
    @Published var currentAnswers: [AnswerModel.Answer] = []
    @Published var currentTextAnswer: String = ""
    @Dependency(\.apiManager) var apiManager
    
    private var formIsValid: Bool {
        for question in questions {
            if question.required {
                if !currentAnswers.contains(where: { $0.questionId == question.id }) {
                    return false
                }
            }
        }
        return true
    }
    
    init() {
        loadData()
    }
    
    func submit() {
        if formIsValid {
            saveAnswers()
        }
    }
    
    private func saveAnswers() {
        apiManager.saveAnswers(currentAnswers) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            } else if success {
                DispatchQueue.main.async {
                    self.currentAnswers = []
                    self.currentTextAnswer = ""
                }
            }
        }
    }
    
    private func loadData() {
        apiManager.loadData { (questions, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let questions = questions else { return }
            DispatchQueue.main.async {
                self.questions = questions
            }
        }
    }
    
    func updateAnswerForSingleChoiceQuestion(questionId: Int, newAnswer: String, extraText: String?) {
        if let index = currentAnswers.firstIndex(where: { $0.questionId == questionId }) {
            currentAnswers[index].answer = [newAnswer + "" + (extraText ?? "")]
            currentTextAnswer = extraText ?? ""
        } else {
            let question = questions.first(where: { $0.id == questionId })
            currentAnswers.append(AnswerModel.Answer(questionId: questionId, questionType: question?.questionType ?? .single, answer: [newAnswer]))
        }
    }
    
    func updateAnswerForMultipleChoiceQuestion(questionId: Int, newAnswer: String, isSelected: Bool) {
        if let index = currentAnswers.firstIndex(where: { $0.questionId == questionId }) {
            if isSelected {
                currentAnswers[index].answer.append(newAnswer)
            } else {
                currentAnswers[index].answer.removeAll(where: { $0 == newAnswer })
            }
        } else {
            let question = questions.first(where: { $0.id == questionId })
            currentAnswers.append(AnswerModel.Answer(questionId: questionId, questionType: question?.questionType ?? .multiple, answer: isSelected ? [newAnswer] : []))
        }
    }
    
    func updateAnswerForTextQuestion(questionId: Int, newAnswer: String) {
        if let index = currentAnswers.firstIndex(where: { $0.questionId == questionId }) {
            currentAnswers[index].answer[0] = newAnswer
        } else {
            let question = questions.first(where: { $0.id == questionId })
            currentAnswers.append(AnswerModel.Answer(questionId: questionId, questionType: question?.questionType ?? .text, answer: [newAnswer]))
        }
    }
}
