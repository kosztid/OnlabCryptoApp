//
//  SwapInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation

class SwapInteractor{
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    
    func selected(coin:String)->String{
        return model.coins.first(where: {$0.name == coin})?.name ?? "nincsnev"
    }
}
