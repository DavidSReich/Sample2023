//
//  UserDefaultsPropertyWrappers.swift
//  Sample2023
//
//  Created by David S Reich on 7/4/2023.
//

import Foundation

@propertyWrapper
class UserDefaultsType<Type> {
    var domain: UserDefaults
    var key: String
    var defaultValue: Type

    init(domain: UserDefaults = .standard, key: String = "", defaultValue: Type) {
        self.domain = domain
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: Type {
        get {
            domain.value(forKey: key) as? Type ?? defaultValue
        }
        set {
            domain.setValue(newValue, forKey: key)
        }
    }

    var projectedValue: UserDefaultsType<Type> {
        self
    }
}

@propertyWrapper
class UserDefaultsDataType<Type: Codable> {
    let defaultValue: Type

    @UserDefaultsType<Data>(defaultValue: Data()) var userSettingsData

    init(domain: UserDefaults, key: String, defaultValue: Type) {
        self.defaultValue = defaultValue

        $userSettingsData.domain = domain
        $userSettingsData.key = key
        $userSettingsData.defaultValue = (try? JSONEncoder().encode(defaultValue)) ?? Data()
    }

    var wrappedValue: Type {
        get {
            let data = userSettingsData

            let result: Result<Type, SampleError> = data.decodeData()

            if case .success(let value) = result {
                return value
            }

            return defaultValue
        }
        set {
            userSettingsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
}
