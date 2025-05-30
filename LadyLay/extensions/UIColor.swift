/*import SwiftUI

extension UIColor {
    func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }

        let rgb = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    convenience init(_ color: Color) {
            let scanner = Scanner(string: color.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                let b = CGFloat(hexNumber & 0x0000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
            self.init(white: 1.0, alpha: 1.0) // Default fallback
        }
}

extension Color {
    init?(hex: String) {
        let r, g, b: Double

        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = Double((hexNumber & 0xff0000) >> 16) / 255
                g = Double((hexNumber & 0x00ff00) >> 8) / 255
                b = Double(hexNumber & 0x0000ff) / 255

                self.init(red: r, green: g, blue: b)
                return
            }
        }
        return nil
    }
}
*/
