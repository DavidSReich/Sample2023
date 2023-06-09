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

    func allSelectedStrings() -> String {
        var selectedStrings = ""

        for selectedString in selectKeeper {
            let prefix = selectedStrings.isEmpty ? "" : "+"
            selectedStrings.append(prefix + selectedString)
        }

        return selectedStrings
    }
}

struct SelectorView_Previews: PreviewProvider {
    @State static var sheetCancelled = false
    @State static var selectedStrings = ""
    static var previews: some View {
        SelectorView(sheetCancelled: $sheetCancelled, selectedStrings: $selectedStrings, allStrings: [
            "aaaa", "bbb", "cc", "d"
        ])
    }
}
