//
//  OnlabCryptoAppApp.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

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
