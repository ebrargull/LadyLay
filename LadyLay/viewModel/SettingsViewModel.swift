import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var theme: ColorScheme? = nil
    @Published var appThemeColor: Color = Color(hex: UserDefaults.standard.string(forKey: "selectedThemeColor") ?? "#9B59B6") ?? .purple.opacity(0.7)
    @Published var alertMessage: AlertMessage = AlertMessage(isShowing: false, message: "")

    init() {
        theme = getTheme()
    }

    func getTheme() -> ColorScheme? {
        let theme = AppUserDefaults.preferredTheme
        switch theme {
        case 0:
            return nil // Sistem teması
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return nil
        }
    }

    func changeAppTheme(theme: Int) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        switch theme {
        case 1:
            window.overrideUserInterfaceStyle = .light
        case 2:
            window.overrideUserInterfaceStyle = .dark
        default:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }

    func changeAppcolor(color: UIColor) {
        if let hex = color.toHex() {
            UserDefaults.standard.set(hex, forKey: "selectedThemeColor")
            appThemeColor = Color(hex: hex) ?? .purple.opacity(0.7)
            showAlert(message: "changed_app_theme")
        }
    }

    func showAlert(message: String) {
        self.alertMessage = AlertMessage(isShowing: true, message: message)
    }
}

struct AlertMessage {
    var isShowing: Bool
    var message: String
}
