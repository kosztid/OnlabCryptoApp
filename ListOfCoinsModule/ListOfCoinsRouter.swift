//
//  ListOfCoinsRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import SwiftUI

class ListOfCoinsRouter{
    func makeCoinDetailView(coin: CoinModel, model: DataModel) -> some View{
        let presenter = CoinDetailPresenter(interactor: CoinDetailInteractor(coin: coin, model: model))
        return CoinDetailView(presenter: presenter)
    }
}
