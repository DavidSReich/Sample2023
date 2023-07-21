//
//  UserDefaultsManager.swift
//  Sample2023
//
//  Created by David S Reich on 23/3/2023.
//

import Foundation

struct UserDefaultsManager {
    private static let userSettingsKey = "usersettings"
    private static let appDefaults = UserDefaults.standard

    @UserDefaultsDataType<UserSettings>(domain: appDefaults, key: userSettingsKey, defaultValue: .getDefaultUserSettings())
    static var userSettings
}
