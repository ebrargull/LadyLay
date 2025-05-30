import SwiftUI

struct WelcomeScreenView: View {
    @Binding var isLoggedIn: Bool
    @AppStorage("selectedLanguage") private var selectedLanguage = "tr"
    
    @EnvironmentObject var theme: ThemeViewModel

    @State private var showLoginScreen = false
    @State private var showSignUpScreen = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Arka Plan
                ContainerRelativeShape()
                    .fill(
                        LinearGradient(colors: [Color.white, theme.selectedColor.opacity(0.2)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Dil seçici
                    HStack {
                        Spacer()
                        Picker("", selection: $selectedLanguage) {
                            Text("🇹🇷").tag("tr")
                            Text("🇺🇸").tag("en")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                    }

                    Spacer()

                    // Başlık ve görsel
                    Text("LadyLay")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .italic()
                        .foregroundStyle(theme.selectedColor)
                        .shadow(color: theme.selectedColor.opacity(0.3), radius: 4, x: 0, y: 4)

                    Image("flower")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 360)
                        .shadow(radius: 10)

                    // Metinler
                    Text("welcome")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(theme.selectedColor)

                    Text("tagline")
                        .font(.callout)
                        .italic()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Giriş Yap Butonu
                    NavigationLink(destination: LoginScreenView(isLoggedIn: $isLoggedIn).environmentObject(theme), isActive: $showLoginScreen) {
                        Button(action: {
                            showLoginScreen = true
                        }) {
                            Label("login", systemImage: "arrow.right.circle.fill")
                                .font(.title2)
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(theme.selectedColor)
                                .cornerRadius(12)
                                .padding(.horizontal, 40)
                        }
                    }

                    // Kayıt Ol Linki
                    NavigationLink(destination: SignUpScreenView(isLoggedIn: $isLoggedIn).environmentObject(theme), isActive: $showSignUpScreen) {
                        Button(action: {
                            showSignUpScreen = true
                        }) {
                            Text("no_account_signup")
                                .font(.footnote)
                                .italic()
                                .foregroundColor(theme.selectedColor)
                                .underline()
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }
                .padding()
            }
            .environment(\.locale, Locale(identifier: selectedLanguage == "tr" ? "tr_TR" : "en_US"))
        }
    }
}
