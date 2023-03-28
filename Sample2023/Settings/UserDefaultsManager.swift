//
//  UserDefaultsManager.swift
//  Sample2023
//
//  Created by David S Reich on 23/3/2023.
//

import Foundation

struct UserDefaultsManager {
    static let userSettingsKey = "usersettings"
    private static let appDefaults = UserDefaults.standard

    static func getUserSettings(defaults: UserDefaults = Self.appDefaults) -> UserSettings {
        if let userSettingsData = defaults.object(forKey: userSettingsKey) as? Data {
            return UserSettings.decodeUserSettings(data: userSettingsData)
        }

        return UserSettings.getDefaultUserSettings()
    }

    static func saveUserSettings(userSettings: UserSettings, defaults: UserDefaults = Self.appDefaults) {
        defaults.set(userSettings.getUserSettingsData(), forKey: userSettingsKey)
    }
}
