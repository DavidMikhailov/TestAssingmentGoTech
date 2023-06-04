//
//  AnswerModel.swift
//  Questionnaire
//
//  Created by David Mikhailov on 03/06/2023.
//

import Foundation

struct AnswerModel: Codable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var answers: [Answer]
    
    struct Answer: Codable {
        let questionId: Int
        let questionType: QuestionModel.QuestionType
        var answer: [String]
    }
}
