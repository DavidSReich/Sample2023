//
//  MainView.swift
//  Sample2023
//
//  Created by David S Reich on 20/3/2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel

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
            // Xcode insists on indenting like this ... it's horrible
            .sheet(item: $mainViewModel.sheetType,
                   onDismiss: {
                mainViewModel.dismissSheet()
            },
                   content: { sheetType in
                if sheetType == .settings {
                    SettingsView(sheetCancelled: $mainViewModel.sheetCancelled, settingsChanged: $mainViewModel.settingsChanged)
                } else {
                    SelectorView(sheetCancelled: $mainViewModel.sheetCancelled,
                                 selectedStrings: $mainViewModel.nextImageTags,
                                 allStrings: mainViewModel.tagsArray)
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                MainToolBar(mainViewModel: mainViewModel)
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
        if mainViewModel.userSettings.giphyAPIKey.isEmpty {
            return Alert(title: Text("API Key is missing"),
                         message: Text("Go to Settings to enter an API Key"),
                         dismissButton: .default(Text("OK ... I guess")))
        } else {
            return Alert(title: Text("Something went wrong!"),
                         message: Text(mainViewModel.errorString),
                         dismissButton: .default(Text("OK ... I guess")))
        }
    }

    struct MainToolBar: ToolbarContent {
        @ObservedObject var mainViewModel: MainViewModel

        var body: some ToolbarContent {
            ToolbarItem(placement: .principal) {
                Text(mainViewModel.title)
            }
            // this is Xcode's least ugly Button formatting that doesn't trigger any SwiftLint warnings!
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    if mainViewModel.isBackButtonSettings {
                        mainViewModel.settingsChanged = false
                        mainViewModel.sheetCancelled = false
                        mainViewModel.sheetType = .settings
                    } else {
                        mainViewModel.goBack(toTop: false)
                    }
                },
                       label: {
                    // it appears that some of these settings are carried to the navigation title !!!
                    Text(mainViewModel.backButtonText).frame(width: UIScreen.main.bounds.width * 0.25).lineLimit(1)
                })
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    if mainViewModel.isRightButtonPickTags {
                        mainViewModel.nextImageTags = ""
                        mainViewModel.sheetCancelled = false
                        mainViewModel.sheetType = .selector
                    } else {
                        mainViewModel.goBack(toTop: true)
                    }
                },
                       label: {
                    Text(mainViewModel.rightButtonText)
                })
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var dataSource = MockDataSource()
    static var mainViewModel = MainViewModel(dataSource: dataSource, userSettings: UserDefaultsManager.userSettings)

    static var previews: some View {
        MainView(mainViewModel: mainViewModel)
    }
}
