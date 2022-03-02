//
//  PortfolioRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 02..
//

import Foundation
import SwiftUI

class PortfolioRouter{
    func makeCoinDetailView(coin: CoinModel, model: DataModel) -> some View{
        let presenter = CoinDetailPresenter(interactor: CoinDetailInteractor(coin: coin, model: model))
        return CoinDetailView(presenter: presenter)
    }
}
