//
//  APIManager.swift
//  Questionnaire
//
//  Created by David Mikhailov on 04/06/2023.
//

import Foundation

protocol APIManagerProtocol {
    func loadData(completion: @escaping ([QuestionModel]?, Error?) -> Void)
    func saveAnswers(_ answers: [AnswerModel.Answer], completion: @escaping (Bool, Error?) -> Void)
}

class APIManager: NSObject, APIManagerProtocol {
    
    func loadData(completion: @escaping ([QuestionModel]?, Error?) -> Void) {
        guard let url = URL(string: Constants.urlQuestions) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else { return }
            do {
                let jsonData = try JSONDecoder().decode([QuestionModel].self, from: data)
                completion(jsonData, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func saveAnswers(_ answers: [AnswerModel.Answer], completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: Constants.urlAnswers) else { return }
        var request = URLRequest(url: url)
        let answerModel = AnswerModel(answers: answers)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(answerModel) {
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(false, error)
                } else if data != nil {
                    completion(true, nil)
                }
            }.resume()
        } else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Encoding failed"]))
        }
    }
}
