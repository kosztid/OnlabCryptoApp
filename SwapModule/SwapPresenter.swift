//
//  SwapPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import Combine
import SwiftUI

class SwapPresenter:ObservableObject{
    @Published var buyorsell : String = "none"
    @Published var coin1 : String = "ethereum"
    @Published var coin2 : String = "tether"
    @Published var coinstobuy : Double = 0
    @Published var coinstosell : Double = 0
    private let router = SwapRouter()
    private let interactor: SwapInteractor
    @Published var coins: [CoinModel] = []
    @Published var ownedcoins: [CoinDataFirebase] = []
    private var cancellables = Set<AnyCancellable>()
    @State private var showingAlert = false
    
    init(interactor: SwapInteractor){
        self.interactor = interactor
        
        interactor.model.$coins
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
        
        interactor.model.$ownedcoins
            .assign(to: \.ownedcoins, on: self)
            .store(in: &cancellables)
    }
    
    func makeButtonForSelector(coin: String) -> some View {
        NavigationLink("Select coin", destination: router.makeSelectorView(presenter: self,coin: coin))
    }
    
    func setSellAmount(){
        if self.buyorsell == "buy" {
            self.buyorsell = "none"
            let coin1 = self.selected(coin: coin1)
            let coin2 = self.selected(coin: coin2)
            let amount = coin2.currentPrice*coinstobuy
            self.coinstosell = amount / coin1.currentPrice
        } else {
            self.buyorsell = "none"
        }
    }
    
    func setBuyAmount(){
        if self.buyorsell == "sell" {
            self.buyorsell = "none"
            let coin1 = self.selected(coin: coin1)
            let coin2 = self.selected(coin: coin2)
            let amount = coin1.currentPrice*coinstosell
            self.coinstobuy = amount / coin2.currentPrice
        } else {
            self.buyorsell = "none"
        }
    }
    
    func selected(coin:String)->CoinModel{
        return interactor.selected(coin: coin)
    }
    func swap(){
        interactor.swap(cointosell: coin1, sellamount: coinstosell, cointobuy: coin2, buyamount: coinstobuy)
    }
}
