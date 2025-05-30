import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("preferredTheme") private var themeType = 0
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    @EnvironmentObject var theme: ThemeViewModel

    var body: some View {
        NavigationStack {
            contentView
                .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(
            themeType == 1 ? .light :
            themeType == 2 ? .dark :
            nil
        )
    }

    @ViewBuilder
    private var contentView: some View {
        if !hasLaunchedBefore {
            OnboardingView(onFinish: {
                hasLaunchedBefore = true
            })
        } else if isLoggedIn {
            TabScreenView(isLoggedIn: $isLoggedIn)
        }else {
            WelcomeScreenView(isLoggedIn: $isLoggedIn)
                    .environmentObject(theme) // 🔥 Tema aktarılıyor
        }
    }
}
