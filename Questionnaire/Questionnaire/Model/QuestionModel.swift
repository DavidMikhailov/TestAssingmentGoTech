//
//  QuestionModel.swift
//  Questionnaire
//
//  Created by David Mikhailov on 01/06/2023.
//

import Foundation

struct QuestionModel: Codable, Identifiable {
    enum QuestionType: String, Codable {
        case single
        case multiple
        case text
    }
    
    let id: Int
    let questionText: String
    let questionType: QuestionType
    let answerOptions: [String]
    let required: Bool
}

