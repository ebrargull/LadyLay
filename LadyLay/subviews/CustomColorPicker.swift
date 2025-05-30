import SwiftUI

struct CustomColorPicker: View {
    var colors: [UIColor]
    var completion: (UIColor) -> ()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 20) {
                ForEach(0..<colors.count, id: \.self) { index in
                    ZStack(alignment: .center) {
                        Button(action: {
                            self.completion(self.colors[index]) // ✅ UIColor döndürdük
                        }) {
                            Circle()
                                .fill(Color(self.colors[index]))
                                .frame(width: 30, height: 30)
                        }
                    }
                    .frame(width: 36, height: 36)
                }
            }
            .padding(8)
        }
    }
}
