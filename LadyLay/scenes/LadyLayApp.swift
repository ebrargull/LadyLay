import SwiftUI
import FirebaseCore

@main
struct LadyLayApp: App {
    
    @StateObject private var settings = SettingsViewModel()
    @StateObject private var theme = ThemeViewModel()
    @State private var isLoggedIn = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
                    .environmentObject(settings)
                    .environmentObject(theme)
            }
        }
    }
}
