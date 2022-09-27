//
//  FavfolioListItemPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 19..
//

import Foundation
import SwiftUI

class FavfolioListItemPresenter: ObservableObject{
    private let interactor: FavfolioListItemInteractor
    
    init(interactor: FavfolioListItemInteractor){
        self.interactor = interactor
    }
    
    func getcoin() -> CoinModel{
        return interactor.getcoin()
    }
    func makeFavButton() -> some View {
        Button(){
            self.interactor.addFavCoin()
        } label: {
            Label("",systemImage: interactor.isFav() ? "star.fill" : "star")
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 22))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
