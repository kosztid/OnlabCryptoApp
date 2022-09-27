//
//  CommunityAdderInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 01..
//

import Foundation

class CommunityAdderInteractor{
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }

    func addCommunity(name: String){
        model.addCommunity(name: name)
    }
}
