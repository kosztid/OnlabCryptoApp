import SwiftUI
import Firebase

@main
struct OnlabCryptoAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
