//
//  OnlabCryptoAppApp.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

@main
struct OnlabCryptoAppApp: App {
    @StateObject private var modelData = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
