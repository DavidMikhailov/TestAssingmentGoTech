//
//  Checkbox.swift
//  Questionnaire
//
//  Created by David Mikhailov on 03/06/2023.
//

import Foundation
import SwiftUI

struct Checkbox: View {
    let label: String
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            self.onTap()
        }) {
            HStack {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Image(systemName: "circle")
                }
                Text(label)
                    .foregroundColor(.black)
            }
        }
    }
}
