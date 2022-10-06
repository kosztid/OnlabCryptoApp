//
//  PriceNotificationPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 02..
//

import Foundation
import Combine

class PriceNotificationPresenter: ObservableObject {
    private let interactor: PriceNotificationInteractor
    @Published var events: [ChangeDataModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: PriceNotificationInteractor) {
        self.interactor = interactor

        interactor.model.$events
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
    }

    func currentPrice(coinid: String) -> Double {
        return interactor.currentPrice(coinid: coinid)
    }
    func coinname(coinid: String) -> String {
        return interactor.coinname(coinid: coinid)
    }

}
