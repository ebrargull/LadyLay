import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("👋 Hoş Geldin!")
                .font(.largeTitle.bold())

            Text("Uygulamayı daha iyi tanımak için kısa bir tur atabiliriz.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            Button(action: {
                onFinish()
            }) {
                Text("Başlayalım")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
