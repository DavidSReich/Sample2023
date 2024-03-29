//
//  StepperField.swift
//  Sample2023
//
//  Created by David S Reich on 23/3/2023.
//

import SwiftUI

struct StepperField: View {
    var title: String
    @Binding var value: Int
    var range: ClosedRange<Int>
    var accessibilityLabel: String

    var body: some View {
        Stepper(value: $value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value)")
            }
        }
        .accessibility(identifier: title)
        .accessibility(value: Text("\(value)"))
    }
}

#Preview("StepperField") {
    @State var stepping = 7
    return StepperField(title: "", value: $stepping, range: 5...30, accessibilityLabel: "stepper")
}
