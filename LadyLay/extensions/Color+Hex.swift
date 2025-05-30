import SwiftUI
import UIKit

// MARK: - UIColor to Hex String
extension UIColor {
    func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }

        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255)
        return String(format: "#%06X", rgb)
    }

    // UIColor initializer from SwiftUI Color
    convenience init(_ color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 1
        var g: CGFloat = 1
        var b: CGFloat = 1
        var a: CGFloat = 1
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// MARK: - SwiftUI Color from Hex
extension Color {
    init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        guard hexString.count == 6,
              let hexNumber = UInt64(hexString, radix: 16) else {
            return nil
        }

        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
        let b = Double(hexNumber & 0x0000FF) / 255

        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}
