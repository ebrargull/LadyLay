import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {
    let auth: Auth
    static let shared = FirebaseManager()

    private override init() {
        self.auth = Auth.auth()
        super.init()
    }
}
