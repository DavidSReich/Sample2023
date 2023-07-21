//
//  SelectorView.swift
//  Sample2023
//
//  Created by David S Reich on 23/3/2023.
//

import SwiftUI

struct SelectorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var sheetCancelled: Bool
    @Binding var selectedStrings: String

    @State private var selectKeeper = Set<String>()

    var allStrings: [String]

    var body: some View {
        NavigationView {
            VStack {
                Text(allSelectedStrings()).padding(.horizontal)
                Spacer()
                List(allStrings, id: \.self, selection: $selectKeeper) { name in
                    Text(name)
                }
                .environment(\.editMode, .constant(EditMode.active))
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Select tags")
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            selectedStrings = ""
                            sheetCancelled = true
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Go!") {
                            selectedStrings = allSelectedStrings()
                            dismiss()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func allSelectedStrings() -> String {
        var selectedStrings = ""

        // this could probably be done more cleverly using .map
        for selectedString in selectKeeper {
            let prefix = selectedStrings.isEmpty ? "" : "+"
            selectedStrings.append(prefix + selectedString)
        }

        return selectedStrings
    }
}

#Preview("") {
    @State var sheetCancelled = false
    @State var selectedStrings = ""

    return SelectorView(sheetCancelled: $sheetCancelled, selectedStrings: $selectedStrings, allStrings: [
        "aaaa", "bbb", "cc", "d"
    ])
}
