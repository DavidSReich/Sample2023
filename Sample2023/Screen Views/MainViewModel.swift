//
//  MainViewModel.swift
//  Sample2023
//
//  Created by David S Reich on 21/3/2023.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var imageModels: [ImageDataModel] = []
    @Published var isLoading = false
    @Published var showingAlert = false
    @Published var settingsChanged = false

    @Published var nextImageTags = ""

    enum SheetType: String, Identifiable {
        case selector
        case settings

        var id: String { rawValue }
    }

    @Published var sheetType: SheetType?
    @Published var sheetCancelled = false

    @Published var selectedImageModel: ImageDataModel?
    @Published var showImage = false

    private var alreadyLoaded = false
    private var lastReferenceError: SampleError?

    private let settingsButtonText = "Settings"
    private let pickTagsButtonText = "Pick Tags"
    private let startButtonText = "Start"

    private var dataSource: DataSource
    var userSettings: UserSettings

    private var imageTags: String

    init(dataSource: DataSource, userSettings: UserSettings) {
        self.dataSource = dataSource
        self.userSettings = userSettings
        imageTags = userSettings.initialTags
    }

    var tagString: String {
        get {
            imageTags
        }

        set {
            imageTags = newValue
        }
    }

    private var mainViewLevel = 0
    private var isTopMainLevel = true

    var title: String {
        isTopMainLevel ? "Starting Images" : dataSource.title
    }

    var isBackButtonSettings: Bool {
        isTopMainLevel
    }

    var isRightButtonPickTags: Bool {
        mainViewLevel <= userSettings.maxNumberOfLevels
    }

    var backButtonText: String {
        isBackButtonSettings ? settingsButtonText : dataSource.penultimateTitle
    }

    var rightButtonText: String {
        isRightButtonPickTags ? pickTagsButtonText : startButtonText
    }

    var errorString: String {
        lastReferenceError?.errorDescription ?? ""
    }

    // DataSource:

    func goBackOneLevel() {
        imageModels = dataSource.popResults() ?? []
    }

    func goBackToTop() {
        imageModels = dataSource.popToTop() ?? []
    }

    func clearDataSource() {
        dataSource.clearAllResults()
        imageModels = dataSource.currentResults ?? []
    }

    var tagsArray: [String] {
        dataSource.tagsArray
    }

    private func populateDataSource(imageTags: String) {
        self.imageTags = imageTags
        let urlString = userSettings.getFullUrlString(tags: imageTags)

        showingAlert = false
        isLoading = true
        lastReferenceError = nil

        dataSource.getData(tagString: imageTags,
                           urlString: urlString,
                           mimeType: "application/json") { refError in
            Task {
                await MainActor.run {
                    self.updateDataSourceDependencies(refError: refError)
                }
            }
        }
    }

    private func updateDataSourceDependencies(refError: SampleError?) {
        imageModels = dataSource.currentResults ?? []
        lastReferenceError = refError
        isLoading = false
        showingAlert = refError != nil
        if !imageModels.isEmpty {
            selectedImageModel = imageModels[0]
        }

        mainViewLevel = max(dataSource.resultsDepth - 1, 0)
        isTopMainLevel = mainViewLevel == 0
    }

    func taskLoadEverything() {
        guard !alreadyLoaded else { return }

        alreadyLoaded = true
        loadEverything()
    }

    func loadEverything() {
        // reset
        imageModels.removeAll()

        self.populateDataSource(imageTags: self.tagString)
    }

    func goBack(toTop: Bool) {
        if toTop {
            goBackToTop()
        } else {
            goBackOneLevel()
        }
        updateDataSourceDependencies(refError: nil)
    }

    func dismissSheet() {
        guard !sheetCancelled else { return }

        if settingsChanged {
            userSettings = UserDefaultsManager.userSettings
            tagString = userSettings.initialTags
            clearDataSource()
            loadEverything()
            settingsChanged = false
        } else if !nextImageTags.isEmpty {
            tagString = nextImageTags
            loadEverything()
            nextImageTags = ""
        }
    }
}
