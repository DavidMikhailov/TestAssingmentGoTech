//
//  QuestionnaireApp.swift
//  Questionnaire
//
//  Created by David Mikhailov on 01/06/2023.
//

import SwiftUI

@main
struct QuestionnaireApp: App {
    var body: some Scene {
        WindowGroup {
            QuestionnaireView(viewModel: QuestionnaireViewModel())
        }
    }
}
