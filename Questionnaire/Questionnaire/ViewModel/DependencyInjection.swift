//
//  DependencyInjection.swift
//  Questionnaire
//
//  Created by David Mikhailov on 04/06/2023.
//

import Foundation
import Dependency

private struct APIManagerKey: DependencyKey {
    static var currentValue: APIManagerProtocol = APIManager()
}

extension DependencyValues {
    var apiManager: APIManagerProtocol {
        get { Self[APIManagerKey.self] }
        set { Self[APIManagerKey.self] = newValue }
    }
}
