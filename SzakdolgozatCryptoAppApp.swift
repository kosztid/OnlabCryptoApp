import Firebase
import SwiftUI

@main
struct SzakdolgozatCryptoAppApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
