import Foundation

class AppRouter: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    func logIn() {
        isLoggedIn = true
    }

    func logOut() {
        isLoggedIn = false
    }
}
