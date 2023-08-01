//
//  MainView.swift
//  Sample2023
//
//  Created by David S Reich on 20/3/2023.
//

import SwiftUI

struct MainView: View {
    @Bindable var mainViewModel: MainViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        ForEach(mainViewModel.imageModels.indices, id: \.self) { index in
                            NavigationLink(value: mainViewModel.imageModels[index]) {
                                ImageRowView(imageDataModel: mainViewModel.imageModels[index], showOnLeft: index.isMultiple(of: 2))
                            }
                        }
                    }
                }

                if mainViewModel.isLoading {
                    ProgressView("Downloading…")
                }
            }
            .navigationDestination(for: ImageDataModel.self) { imageDataModel in
                ImageView(imageDataModel: imageDataModel)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                MainToolBar(mainViewModel: mainViewModel)
            }
            .sheet(item: $mainViewModel.sheetType,
                   onDismiss: mainViewModel.dismissSheet) { sheetType in
                if sheetType == .settings {
                    SettingsView(sheetCancelled: $mainViewModel.sheetCancelled, settingsChanged: $mainViewModel.settingsChanged)
                } else {
                    SelectorView(sheetCancelled: $mainViewModel.sheetCancelled,
                                 selectedStrings: $mainViewModel.nextImageTags,
                                 allStrings: mainViewModel.tagsArray)
                }
            }
        }
        .alert(isPresented: $mainViewModel.showingAlert) {
            alertViews()
        }
        .task {
            mainViewModel.taskLoadEverything()
        }
    }

    private func alertViews() -> Alert {
        if mainViewModel.giphyAPIKeyIsEmpty {
            Alert(title: Text("API Key is missing"),
                  message: Text("Go to Settings to enter an API Key"),
                  dismissButton: .default(Text("OK ... I guess")))
        } else {
            Alert(title: Text("Something went wrong!"),
                  message: Text(mainViewModel.errorString),
                  dismissButton: .default(Text("OK ... I guess")))
        }
    }

    private struct MainToolBar: ToolbarContent {
        var mainViewModel: MainViewModel

        var body: some ToolbarContent {
            ToolbarItem(placement: .principal) {
                Text(mainViewModel.title)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    if mainViewModel.isBackButtonSettings {
                        mainViewModel.settingsChanged = false
                        mainViewModel.sheetCancelled = false
                        mainViewModel.sheetType = .settings
                    } else {
                        mainViewModel.goBack(toTop: false)
                    }
                } label: {
                    // it appears that some of these settings are carried to the navigation title !!!
                    Text(mainViewModel.backButtonText).frame(width: UIScreen.main.bounds.width * 0.25).lineLimit(1)
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    if mainViewModel.isRightButtonPickTags {
                        mainViewModel.nextImageTags = ""
                        mainViewModel.sheetCancelled = false
                        mainViewModel.sheetType = .selector
                    } else {
                        mainViewModel.goBack(toTop: true)
                    }
                } label: {
                    Text(mainViewModel.rightButtonText)
                }
            }
        }
    }
}

#Preview("MainView") {
    MainView(mainViewModel: MainViewModel(dataSource: MockDataSource(), userSettings: UserDefaultsManager.userSettings))
}
