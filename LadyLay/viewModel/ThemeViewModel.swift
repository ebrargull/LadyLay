import SwiftUI

class ThemeViewModel: ObservableObject {
    @AppStorage("selectedThemeColor") var selectedThemeColorHex: String = "#9B59B6" {
        didSet {
            objectWillChange.send()
        }
    }

    var selectedColor: Color {
        Color(hex: selectedThemeColorHex) ?? .purple
    }
}
