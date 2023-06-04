//
//  RequiredLabel.swift
//  Questionnaire
//
//  Created by David Mikhailov on 03/06/2023.
//

import Foundation
import SwiftUI

struct QuestionLabel: View {
    let label: String
    var isRequired: Bool
    
    var body: some View {
        HStack {
            Text(label)
            if isRequired {
                Text("*")
                    .foregroundColor(.red)
            }
        }
    }
}
