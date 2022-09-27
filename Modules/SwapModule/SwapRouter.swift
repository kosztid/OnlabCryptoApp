//
//  SwapRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 23..
//

import Foundation
import SwiftUI

class SwapRouter{
    
    func makeSelectorView(presenter: SwapPresenter, coin:String) -> some View {
        SearchView(coinname: coin, presenter: presenter)
    }
}
