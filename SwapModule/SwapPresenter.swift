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
    @Published var coin1 : String = "Bitcoin"
    @Published var coin2 : String = "Tether"
    private let router = SwapRouter()
    private let interactor: SwapInteractor
    @Published var coins: [CoinModel] = []
    private var cancellables = Set<AnyCancellable>()
    @State private var showingAlert = false
    
    init(interactor: SwapInteractor){
        self.interactor = interactor
        
        interactor.model.$coins
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
    }
    
    func makeButtonForSelector(coin: String) -> some View {
        NavigationLink("Select coin", destination: router.makeSelectorView(presenter: self,coin: coin))
    }
    func selected(coin:String)->CoinModel{
        return interactor.selected(coin: coin)
    }
}
