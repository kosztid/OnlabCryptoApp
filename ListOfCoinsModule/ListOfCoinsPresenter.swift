//
//  ListOfCoinsPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import SwiftUI
import Combine

class ListOfCoinsPresenter: ObservableObject{
    @Published var coins: [CoinModel] = []
    private let interactor: ListOfCoinsInteractor
    private var cancellables = Set<AnyCancellable>()
    private let router = ListOfCoinsRouter()
    
    init(interactor: ListOfCoinsInteractor){
        self.interactor = interactor
        interactor.model.$coins
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
    }
    
    func linkBuilder<Content: View>(
        for coin: CoinModel,
        @ViewBuilder content: () -> Content
    ) -> some View{
        NavigationLink(destination:router.makeCoinDetailView(coin: coin,model: interactor.model)){
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
    
}
