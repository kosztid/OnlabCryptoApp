//
//  SwapPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import Combine
import SwiftUI

class SwapPresenter: ObservableObject {
    @Published var buyorsell = "none"
    @Published var coin1 = "ethereum"
    @Published var coin2 = "tether"
    @Published var coinstosell = 0.0
    @Published var coinstobuy = 0.0
    private let router = SwapRouter()
    let interactor: SwapInteractor
    @Published var coins: [CoinModel] = []
    @Published var ownedcoins: [CryptoServerModel] = []
    private var cancellables = Set<AnyCancellable>()
    @State private var showingAlert = false

    init(interactor: SwapInteractor) {
        self.interactor = interactor

        interactor.model.$coin1
            .assign(to: \.coin1, on: self)
            .store(in: &cancellables)

        interactor.model.$coin2
            .assign(to: \.coin2, on: self)
            .store(in: &cancellables)
        
        interactor.model.$coinstobuy
            .assign(to: \.coinstobuy, on: self)
            .store(in: &cancellables)

        interactor.model.$coinstosell
            .assign(to: \.coinstosell, on: self)
            .store(in: &cancellables)
        
        interactor.model.$buyorsell
            .assign(to: \.buyorsell, on: self)
            .store(in: &cancellables)

        interactor.model.$coins
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)

        interactor.model.$ownedcoins
            .assign(to: \.ownedcoins, on: self)
            .store(in: &cancellables)
    }

    func makeButtonForSelector(coin: String) -> some View {
        NavigationLink("Select coin", destination: router.makeSelectorView(presenter: self, coin: coin))
    }

    func setSellAmount() {
            let coin1 = self.selected(coin: coin1)
            let coin2 = self.selected(coin: coin2)
            let amount = coin2.currentPrice*coinstobuy
            interactor.setCoinstoSell(amount: amount / coin1.currentPrice)

    }

    func setBuyAmount() {
            let coin1 = self.selected(coin: coin1)
            let coin2 = self.selected(coin: coin2)
            let amount = coin1.currentPrice*coinstosell
            interactor.setCoinstoBuy(amount: amount / coin2.currentPrice )

    }

    func selected(coin: String) -> CoinModel {
        return interactor.selected(coin: coin)
    }

    func swap() {
        interactor.swap(cointosell: coin1, sellamount: coinstosell, cointobuy: coin2, buyamount: coinstobuy)
        coinstosell = 0.0
        coinstobuy = 0.0
    }
    
    func setCoinstobuy(amount: Double) {
        interactor.setCoinstoBuy(amount: amount)
    }

    func setCoinstosell(amount: Double) {
        interactor.setCoinstoSell(amount: amount)
    }
    
    func setCoin1(coin1: String) {
        interactor.setCoin1(coin1: coin1)
    }

    func setCoin2(coin2: String) {
        interactor.setCoin2(coin2: coin2)
    }

    func setBuyorSell(boolean: String) {
        interactor.setBuyorSell(boolean: boolean)
    }

    func returnmodel() -> DataModel {
        return interactor.model
    }

    func ownedamount(coin: String) -> Double {
        return interactor.ownedamount(coin: selected(coin: coin))
    }

    func isOwned(coin: CoinModel) -> Bool {
        return interactor.isOwned(coin: coin)
    }

    func makeButtonForSwap() -> some View {
        Button {
            self.swap()
        } label: {
            Text("Swap")
                .frame(height: 60)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .foregroundColor(Color.theme.accentcolor)
                .background(Color.theme.backgroundsecondary)
                .cornerRadius(10)
        }
    }
}
