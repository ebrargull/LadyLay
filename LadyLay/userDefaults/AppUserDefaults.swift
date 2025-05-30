//
//  AppUserDefault.swift
//  DailyApp
//
//  Created by Ebrar Gül on 18.06.2024.
//

import Foundation

struct AppUserDefaults{
    
    @UserDefault(key: "appThemeColor", defaultValue: "")
    static var appThemeColor: String
    
    @UserDefault(key: "preferredTheme", defaultValue: 0 )
    static var preferredTheme: Int
    
    @UserDefault(key: "counter", defaultValue: 1)
    static var counter: Int
}
