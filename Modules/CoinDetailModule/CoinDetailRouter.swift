//
//  CoinDetailRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 02..
//

import Foundation
import SwiftUI

class CoinDetailRouter{
    
    func makeAdderView(coincount: Double,coin: CoinModel,model: DataModel) -> some View{
        let presenter = PortfolioAdderPresenter(interactor: PortfolioAdderInteractor(coin: coin,model: model))
        return PortfolioAdderView(presenter: presenter, coincount: coincount)
    }
    
}
