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
    
    func makeAccountView(model: DataModel) -> some View {
        return AccountView(presenter: AccountPresenter(interactor: AccountInteractor(model: model)))
    }
    
    func makeLoginView(model: DataModel) -> some View{
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor(model: model))
        return LoginScreenView(presenter: presenter)
    }
}
