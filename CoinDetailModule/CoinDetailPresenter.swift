//
//  CoinDetailPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI

class CoinDetailPresenter: ObservableObject{
    private let interactor: CoinDetailInteractor
    private let router = CoinDetailRouter()
    
    init(interactor: CoinDetailInteractor){
        self.interactor = interactor
    }
    
    func values() -> [CGFloat]{
        return interactor.getvalues()
    }
    func getcoin() -> CoinModel{
        return interactor.getcoin()
    }
    func getmodel() -> DataModel{
        return interactor.getmodel()
    }
    /*
    func detailed() -> CoinDetailModel{
        return interactor.getcoindetail()
    }
    
     */
    func makeButtonForPortfolioAdderView() -> some View {
        NavigationLink("Add", destination: router.makeAdderView(coin:interactor.getcoin(), model: interactor.getmodel()))
    }
}
