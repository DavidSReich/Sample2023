//
//  SettingsView.swift
//  Sample2023
//
//  Created by David S Reich on 23/3/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var sheetCancelled: Bool
    @Binding var settingsChanged: Bool

    @State var userSettings = UserDefaultsManager.userSettings

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Registration").font(.subheadline)) {
                    HStack {
                        Text("GIPHY API Key")
                        TextField("", text: $userSettings.giphyAPIKey).multilineTextAlignment(.trailing)
                            .accessibility(identifier: "GiphyAPIKeyTextField")
                    }
                    Link(destination: URL(string: "https://developers.giphy.com/dashboard/?create=true")!) {
                        HStack {
                            Text("Get your GIPHY key here ...")
                            Spacer()
                            Image(systemName: "link.circle.fill")
                        }
                    }
                    HStack {
                        Text("To use GIPHY in this app you need to create a GIPHY account, " +
                             "and then create an App there to get an API Key.")
                        Spacer()
                    }
                }
                Section(header: Text("Tags").font(.subheadline)) {
                    HStack {
                        Text("Starting Tags")
                        TextField("", text: $userSettings.initialTags).multilineTextAlignment(.trailing)
                            .accessibility(identifier: "TagsTextField")
                    }
                }
                Section(header: Text("Limits").font(.subheadline)) {
                    StepperField(title: "Max # of images",
                                 value: $userSettings.maxNumberOfImages,
                                 range: 5...30,
                                 accessibilityLabel: "Max number of images")
                    StepperField(title: "Max # of levels",
                                 value: $userSettings.maxNumberOfLevels,
                                 range: 5...20,
                                 accessibilityLabel: "Max number of levels")
                }
            }
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        sheetCancelled = true
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack {
                        Button("Reset") {
                            userSettings = UserDefaultsManager.userSettings
                        }

                        Button("Apply") {
                            if UserDefaultsManager.userSettings != userSettings {
                                UserDefaultsManager.userSettings = userSettings
                                settingsChanged = true
                            }
                            dismiss()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var sheetCancelled = false
    @State static var settingsChanged = false

    static var previews: some View {
        SettingsView(sheetCancelled: $sheetCancelled, settingsChanged: $settingsChanged)
    }
}
