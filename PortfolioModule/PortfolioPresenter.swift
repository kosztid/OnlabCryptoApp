//
//  PortfolioPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//
import Combine
import Foundation
import SwiftUI

class PortfolioPresenter: ObservableObject{
    @Published var coins: [CoinModel] = []
    private let interactor: PortfolioInteractor
    private var cancellables = Set<AnyCancellable>()
    private let router = PortfolioRouter()
    
    init(interactor: PortfolioInteractor){
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
    
    func heldcoins() -> [String] {
        return interactor.heldcoins()
    }
    
    func removeCoin(_ index: IndexSet){
        interactor.removeCoin(index)
    }
    func getholdingcount(coin: CoinModel) -> Double {
        return interactor.getholdingcount(coin: coin)
    }
    func portfoliototal()-> Double{
        return interactor.portfoliototal()
    }
}
