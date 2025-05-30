//
//  UserDefault.swift
//  DailyApp
//
//  Created by Ebrar Gül on 18.06.2024.
//

import Foundation
@propertyWrapper

struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ??
                defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

