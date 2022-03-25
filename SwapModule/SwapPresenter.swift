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
    @State var coin : String = ""
    @State var searchTerm: String = ""
    private let router = SwapRouter()
    private let interactor: SwapInteractor
    @Published var coins: [CoinModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: SwapInteractor){
        self.interactor = interactor
        
        interactor.model.$coins
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
    }
    
    func makeButtonForSelector() -> some View {
        NavigationLink("Select coin", destination: router.makeSelectorView(presenter: self))
    }
}
