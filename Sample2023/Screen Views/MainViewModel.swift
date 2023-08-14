//
//  MainViewModel.swift
//  Sample2023
//
//  Created by David S Reich on 21/3/2023.
//

import Foundation
import Observation

@Observable class MainViewModel {
    var imageModels: [ImageDataModel] = []
    var isLoading = false
    var showingAlert = false
    var settingsChanged = false

    var nextImageTags = ""

    enum SheetType: String, Identifiable {
        case selector
        case settings

        var id: String { rawValue }
    }

    var sheetType: SheetType?
    var sheetCancelled = false

    var showImage = false

    @ObservationIgnored private var alreadyLoaded = false
    @ObservationIgnored private var lastReferenceError: SampleError?

    private let settingsButtonText = "Settings"
    private let pickTagsButtonText = "Pick Tags"
    private let startButtonText = "Start"

    @ObservationIgnored private var dataSource: DataSource
    @ObservationIgnored private var userSettings: UserSettings

    @ObservationIgnored private var imageTags: String

    init(dataSource: DataSource, userSettings: UserSettings) {
        self.dataSource = dataSource
        self.userSettings = userSettings
        imageTags = userSettings.initialTags
    }

    var giphyAPIKeyIsEmpty: Bool {
        userSettings.giphyAPIKey.isEmpty
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

        lastReferenceError = nil
        Task { @MainActor in
            showingAlert = false
            isLoading = true
        }

        dataSource.getData(tagString: imageTags,
                           urlString: urlString,
                           mimeType: "application/json") { refError in
            self.updateDataSourceDependencies(refError: refError)
        }
    }

    private func updateDataSourceDependencies(refError: SampleError?) {
        lastReferenceError = refError
        Task { @MainActor in
            imageModels = dataSource.currentResults ?? []
            isLoading = false
            showingAlert = refError != nil
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

        populateDataSource(imageTags: tagString)
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
