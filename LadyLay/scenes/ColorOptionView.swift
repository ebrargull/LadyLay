import SwiftUI
struct ColorOptionView: View {
    let hex: String
    let selectedHex: String
    let onSelect: (String) -> Void

    var body: some View {
        Circle()
            .fill(Color(hex: hex) ?? .clear)
            .frame(width: 24, height: 24)
            .onTapGesture {
                onSelect(hex)
            }
            .overlay(
                Circle()
                    .stroke(hex == selectedHex ? Color.black : Color.clear, lineWidth: 2)
            )
    }
}
