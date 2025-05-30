import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

enum SignUpAlertType {
    case success
    case error(String)
}

struct SignUpScreenView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var theme: ThemeViewModel

    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showCustomAlert = false
    @State private var activeAlert: SignUpAlertType? = nil
    @State private var isPasswordSecure = true
    @State private var isConfirmPasswordSecure = true
    @State private var agreedToPrivacy = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "tr"
    @State private var animate = false
    @State private var showLoginScreen = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ContainerRelativeShape()
                    .fill(
                        LinearGradient(colors: [Color.white, theme.selectedColor.opacity(0.2)],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    Text("signup_title")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(theme.selectedColor)
                        .padding(.top, 60)
                    
                    customTextField(icon: "person.fill", placeholder: NSLocalizedString("username_placeholder", comment: ""), text: $username)
                    customTextField(icon: "envelope.fill", placeholder: NSLocalizedString("email_placeholder", comment: ""), text: $email)
                    customPasswordField(icon: "lock.fill", placeholder: NSLocalizedString("password_placeholder", comment: ""), text: $password, isSecure: $isPasswordSecure)
                    customPasswordField(icon: "lock.fill", placeholder: NSLocalizedString("confirm_password_placeholder", comment: ""), text: $confirmPassword, isSecure: $isConfirmPasswordSecure)
                    
                    if !password.isEmpty {
                        HStack {
                            Text(NSLocalizedString(passwordStrength().text, comment: ""))
                                .font(.footnote)
                                .foregroundColor(passwordStrength().color)
                            Spacer()
                            RoundedRectangle(cornerRadius: 4)
                                .fill(passwordStrength().color)
                                .frame(width: CGFloat(min(password.count * 10, 100)), height: 6)
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    Toggle(isOn: $agreedToPrivacy) {
                        Text("privacy_agreement")
                            .font(.footnote)
                    }
                    .toggleStyle(CheckboxToggleStyle(themeColor: theme.selectedColor))
                    .padding(.horizontal, 40)
                    
                    NavigationLink(destination: LoginScreenView(isLoggedIn: $isLoggedIn).environmentObject(theme), isActive: $showLoginScreen){
                        Button(action: {
                            validateAndSignUp()
                            showLoginScreen = true
                            
                        }) {
                            Label(NSLocalizedString("signup_button", comment: ""), systemImage: "person.badge.plus.fill")
                                .font(.title2)
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(theme.selectedColor)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        .opacity(animate ? 1 : 0)
                        .animation(.easeOut.delay(0.5), value: animate)
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.top, 100)
                    
                    
                    if showCustomAlert {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 16) {
                            Image(systemName: alertIcon())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(alertColor())
                            
                            Text(alertTitle())
                                .font(.title2)
                                .bold()
                                .foregroundColor(theme.selectedColor)
                            
                            Text(alertMessage())
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            
                            
                            if case .error(_) = activeAlert {
                                Button {
                                    withAnimation {
                                        showCustomAlert = false
                                    }
                                } label: {
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
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .padding(.horizontal, 40)
                    }
                }
            }
            .onAppear {
                animate = true

            }
            /*.navigationDestination(isPresented: $showLoginScreen) {
                LoginScreenView(isLoggedIn: $isLoggedIn)
                    .environmentObject(theme)
            }*/
            
            .navigationBarHidden(true)
            .environment(\.locale, Locale(identifier: selectedLanguage == "tr" ? "tr_TR" : "en_US"))
            
        }
    }

    func validateAndSignUp() {
        activeAlert = nil

        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            activeAlert = .error("Tüm alanları doldurun.")
            showCustomAlert = true
            return
        }

        guard email.contains("@") else {
            activeAlert = .error("Geçerli bir e-posta adresi girin.")
            showCustomAlert = true
            return
        }

        guard password.count >= 6 else {
            activeAlert = .error("Şifre en az 6 karakter olmalı.")
            showCustomAlert = true
            return
        }

        guard password == confirmPassword else {
            activeAlert = .error("Şifreler uyuşmuyor.")
            showCustomAlert = true
            return
        }

        guard agreedToPrivacy else {
            activeAlert = .error("Gizlilik politikasını kabul etmelisiniz.")
            showCustomAlert = true
            return
        }

        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    activeAlert = .error("Bu e-posta adresi zaten kayıtlı.")
                } else {
                    activeAlert = .error(error.localizedDescription)
                }
                showCustomAlert = true
                return
            }

            guard let uid = result?.user.uid else {
                activeAlert = .error("Kullanıcı ID alınamadı.")
                showCustomAlert = true
                return
            }

            let userData: [String: Any] = [
                "uid": uid,
                "username": username,
                "email": email,
                "createdAt": Timestamp()
            ]

            Firestore.firestore().collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    activeAlert = .error("Veri kaydı hatası: \(error.localizedDescription)")
                    showCustomAlert = true
                } else {
                    activeAlert = .success
                    showCustomAlert = true

                    // ✅ Başarı alertinden sonra login ekranına geç
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        showCustomAlert = false

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showLoginScreen = true
                        }
                    }
                }
            }
        }
    }

    func customTextField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)
            TextField(placeholder, text: text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }

    func customPasswordField(icon: String, placeholder: String, text: Binding<String>, isSecure: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray)

            if isSecure.wrappedValue {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }

            Button {
                isSecure.wrappedValue.toggle()
            } label: {
                Image(systemName: isSecure.wrappedValue ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }

    func passwordStrength() -> (text: String, color: Color) {
        if password.count >= 8 && password.contains(where: { $0.isNumber }) && password.contains(where: { $0.isUppercase }) {
            return ("strong", .green)
        } else if password.count >= 6 {
            return ("medium", .yellow)
        } else {
            return ("weak", .red)
        }
    }

    func alertTitle() -> String {
        switch activeAlert {
        case .success:
            return "Kayıt Başarılı"
        case .error:
            return "Kayıt Hatası"
        case .none:
            return ""
        }
    }

    func alertMessage() -> String {
        switch activeAlert {
        case .success:
            return "Kayıt başarılı! Giriş ekranına yönlendiriliyorsunuz..."
        case .error(let message):
            return message
        case .none:
            return ""
        }
    }

    func alertIcon() -> String {
        switch activeAlert {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.octagon.fill"
        case .none:
            return ""
        }
    }

    func alertColor() -> Color {
        switch activeAlert {
        case .success:
            return .green
        case .error:
            return .red
        case .none:
            return .clear
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    var themeColor: Color

    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(themeColor)
                configuration.label
            }
        }
    }
}
