//
//  PortfolioInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation

class PortfolioInteractor{
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    
    func heldcoins() -> [String] {
        return model.heldcoins
    }
    func removeCoin(_ index: IndexSet){
        model.removeCoin(cointoremove: model.coins[index.first!])
    }
}
