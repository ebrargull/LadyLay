import SwiftUI

enum LoginAlertType {
    case success
    case error
}

struct LoginScreenView: View {
    
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var animate = false
    @State private var showCustomAlert = false
    @State private var showTabScreen = false
    @State private var activeAlert: LoginAlertType? = nil
    @AppStorage("selectedLanguage") private var selectedLanguage = "tr"
    
    @EnvironmentObject var theme: ThemeViewModel // ✅ Tema desteği

    var body: some View {
        ZStack(alignment: .top) {
            // Arka Plan
            ContainerRelativeShape()
                .fill(
                    LinearGradient(colors: [Color.white, theme.selectedColor.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .ignoresSafeArea()

            // Face ID İkonu
            Image(systemName: "faceid")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(theme.selectedColor)
                .padding(.top, 40)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -30)
                .animation(.easeOut.delay(0.2), value: animate)

            VStack(spacing: 24) {
                // LADYLAY Başlığı
                HStack(spacing: 8) {
                    Text("LADYLAY")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .italic()
                        .foregroundStyle(theme.selectedColor)
                    
                    Image(systemName: "bolt.horizontal")
                        .font(.system(size: 32))
                        .foregroundStyle(theme.selectedColor)
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -30)
                .animation(.easeOut.delay(0.3), value: animate)
                
                // Kullanıcı Adı Alanı
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    TextField(NSLocalizedString("username_placeholder", comment: ""), text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -30)
                .animation(.easeOut.delay(0.4), value: animate)
                
                // Şifre Alanı
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    SecureField(NSLocalizedString("password_placeholder", comment: ""), text: $password)
                }
                .padding()
                .background(.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -30)
                .animation(.easeOut.delay(0.5), value: animate)
                
                // Giriş Yap Butonu
                NavigationLink(destination: TabScreenView(isLoggedIn: $isLoggedIn).environmentObject(theme), isActive: $showTabScreen) {
                    Button(action: {
                        if username.isEmpty || password.isEmpty {
                            activeAlert = .error
                        } else {
                            activeAlert = .success
                        }
                        showCustomAlert = true
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showCustomAlert = false
                            }
                            if activeAlert == .success {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isLoggedIn = true
                                    showTabScreen = true
                                }
                            }
                        }
                        
                        /*FirebaseManager.shared.auth.signIn(withEmail: username, password: password) { result, error in
                         if let error = error {
                         print("Login error: \(error.localizedDescription)")
                         activeAlert = .error
                         } else {
                         activeAlert = .success
                         isLoggedIn = true // 🌟 Otomatik olarak TabScreen'e geçilecek
                         }
                         showCustomAlert = true
                         }*/
                    }, label: {
                        Label(NSLocalizedString("login_button", comment: ""), systemImage: "arrow.right.circle.fill")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(theme.selectedColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    })
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : -30)
                    .animation(.easeOut.delay(0.6), value: animate)
                }}
            
            .frame(maxHeight: .infinity)
            .padding(.top, 100)

            // Custom Pop-Up
            if showCustomAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 16) {
                    Image(systemName: activeAlert == .success ? "checkmark.circle.fill" : "xmark.octagon.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(activeAlert == .success ? .green : .red)

                    Text(activeAlert == .success ? NSLocalizedString("login_success_title", comment: "") : NSLocalizedString("login_error_title", comment: ""))
                        .font(.title2)
                        .bold()
                        .foregroundColor(theme.selectedColor)

                    Text(activeAlert == .success ? NSLocalizedString("login_success_message", comment: "") : NSLocalizedString("login_error_message", comment: ""))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    Button(action: {
                        withAnimation {
                            showCustomAlert = false
                        }
                        if activeAlert == .success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isLoggedIn = true
                            }
                        }
                    }) {
                        Text(NSLocalizedString("ok_button", comment: ""))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(theme.selectedColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(.horizontal, 40)
                .transition(.scale)
                .animation(.easeInOut(duration: 0.4), value: showCustomAlert)
            }
        }
        .onAppear {
            animate = true
        }
        .environment(\.locale, Locale(identifier: selectedLanguage == "tr" ? "tr_TR" : "en_US"))
    }
}
