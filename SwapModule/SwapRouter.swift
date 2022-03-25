//
//  SwapRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 23..
//

import Foundation
import SwiftUI

class SwapRouter{
    
    func makeSelectorView(presenter: SwapPresenter) -> some View {
            Picker(selection: presenter.$coin, label: Text("HALLO")) {
                SearchBar(text: presenter.$searchTerm, placeholder: "Search Coins")
                ForEach(presenter.coins) { coin in
                        Text(coin.name)
                }
            }
    }
}
