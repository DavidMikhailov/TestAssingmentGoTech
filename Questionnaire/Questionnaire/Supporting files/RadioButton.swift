//
//  RadioButton.swift
//  Questionnaire
//
//  Created by David Mikhailov on 03/06/2023.
//

import Foundation
import SwiftUI

struct RadioButton: View {
    let label: String
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            self.onTap()
        }) {
            HStack {
                if isSelected {
                    Image(systemName: "record.circle")
                } else {
                    Image(systemName: "circle")
                }
                Text(label)
                    .foregroundColor(.black)
            }
        }
    }
}
