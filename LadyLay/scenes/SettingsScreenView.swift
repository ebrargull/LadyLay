import SwiftUI

struct SettingsScreenView: View {
    @Binding var isLoggedIn: Bool
    
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var theme: ThemeViewModel // 🔥 Global tema erişimi

    @AppStorage("preferredTheme") private var themeType = 0
    @State private var webViewAction = false
    @State private var showWelcomeScreen = false

    let colorOptions: [String] = ["#E91E63", "#9B59B6", "#3498DB", "#1ABC9C", "#FF9800", "#F44336", "#4CAF50", "#3F51B5"]

    private let productURL = URL(string: "https://apps.apple.com/app/id123456789")
    @State private var _url = ""
    @State private var _title = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, theme.selectedColor.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    
                    settingCard(title: "⚙️ Uygulama Tercihleri") {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Tema Rengi")
                                    .font(.subheadline.bold())
                                Spacer()
                                HStack {
                                    ForEach(colorOptions, id: \.self) { hex in
                                        ColorOptionView(hex: hex, selectedHex: theme.selectedThemeColorHex) { selected in
                                            theme.selectedThemeColorHex = selected
                                        }
                                    }
                                }
                            }

                            HStack {
                                Text("Görünüm Modu")
                                    .font(.subheadline.bold())
                                Spacer()
                                Picker("", selection: $themeType) {
                                    Text("Sistem").tag(0)
                                    Text("Açık").tag(1)
                                    Text("Koyu").tag(2)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 160)
                                .onChange(of: themeType) { newValue in
                                    settings.changeAppTheme(theme: newValue)
                                }
                            }
                        }
                    }

                    settingCard(title: "💬 Geri Bildirim") {
                        VStack(spacing: 12) {
                            Button {
                                writeReview()
                            } label: {
                                Label("Bizi Puanla", systemImage: "star.fill")
                                    .font(.body.bold())
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(theme.selectedColor)
                                    .cornerRadius(10)
                            }
                            
                            Button {
                                _url = "https://docs.google.com/forms/d/e/1FAIpQLScwq05zxjTX9nr-2xesT_jYqmVHDwhTkxYOx2pnWzAAvRV-5A/viewform?usp=sf_link"
                                _title = "Geri Bildirim"
                                webViewAction = true
                            } label: {
                                Label("Geri Bildirim Gönder", systemImage: "paperplane.fill")
                                    .font(.body.bold())
                                    .foregroundColor(theme.selectedColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                            .sheet(isPresented: $webViewAction) {
                                WebViewWithNavigationUIView(url: self.$_url, title: self.$_title)
                            }
                            
            NavigationLink(destination: WelcomeScreenView(isLoggedIn: $isLoggedIn).environmentObject(theme), isActive: $showWelcomeScreen){
                            Button(action: {
                                isLoggedIn = false
                                showWelcomeScreen = true
                            }) {
                                Label("Çıkış Yap", systemImage: "rectangle.portrait.and.arrow.right")
                                    .font(.body.bold())
                                    .foregroundColor(theme.selectedColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                            .padding(.top, 16)
                        }
                        }
                    }

                    settingCard(title: "👩‍💻 Geliştirici") {
                        HStack(spacing: 16) {
                            Image("ic_profile")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(radius: 2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ebrar Gül").bold()
                                Text("@ebrargull16")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Button {
                                openTwitter(twitterHandle: "ebrargull16")
                            } label: {
                                Image("ic_twitter")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }

                    Text("LadyLay v1.0.0")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                }
                .padding()
            }
        }
        .navigationTitle("Ayarlar")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Views

    @ViewBuilder
    func settingCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(theme.selectedColor)

            content()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 3)
    }

    // MARK: - Helper Functions

    func writeReview() {
        guard let productURL = productURL else { return }
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write_review")]
        if let writeReviewURL = components?.url {
            UIApplication.shared.open(writeReviewURL)
        }
    }

    func openTwitter(twitterHandle: String) {
        let appURL = URL(string: "twitter://user?screen_name=\(twitterHandle)")!
        let webURL = URL(string: "https://x.com/\(twitterHandle)")!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.open(webURL)
        }
    }
}
