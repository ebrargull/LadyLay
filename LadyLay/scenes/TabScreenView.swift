import SwiftUI

struct TabScreenView: View {
    @EnvironmentObject var theme: ThemeViewModel
    @Binding var isLoggedIn: Bool
    @AppStorage("selectedLanguage") private var selectedLanguage = "tr"
    @State private var selectedTab = 0
    let themeColor = Color.purple.opacity(0.7)

    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarScreenView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label(NSLocalizedString("calendar_tab", comment: ""), systemImage: "calendar")
                }
                .tag(0)

            MapScreenView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label(NSLocalizedString("map_tab", comment: ""), systemImage: "map")
                }
                .tag(1)

            SettingsScreenView(isLoggedIn: $isLoggedIn) // ✅ Bağlantı yapılmalı
                .tabItem {
                    Label(NSLocalizedString("settings_tab", comment: ""), systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .accentColor(theme.selectedColor)
        .environment(\.locale, Locale(identifier: selectedLanguage == "tr" ? "tr_TR" : "en_US"))
    }
}
