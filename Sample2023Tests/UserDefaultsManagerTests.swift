//
//  UserDefaultsManagerTests.swift
//  Sample2023Tests
//
//  Created by David S Reich on 24/3/2023.
//

import XCTest

final class UserDefaultsManagerTests: XCTestCase {
    func testUserDefaultsManager() {
        let initialTags = "initial-Tags"
        let giphyAPIKey = "adsfinflsdfl023r"
        let maxNumberOfImages = 5
        let maxNumberOfLevels = 7

        let firstSettings = UserSettings(initialTags: initialTags,
                                         giphyAPIKey: giphyAPIKey,
                                         maxNumberOfImages: maxNumberOfImages,
                                         maxNumberOfLevels: maxNumberOfLevels)

        UserDefaultsManager.userSettings = firstSettings
        let secondSettings = UserDefaultsManager.userSettings

        XCTAssertEqual(firstSettings, secondSettings)
    }
}
