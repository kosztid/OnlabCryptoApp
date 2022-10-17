import SwiftUI
import Firebase

@main
struct OnlabCryptoAppApp: App {
    @StateObject private var modelData = DataModel()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
