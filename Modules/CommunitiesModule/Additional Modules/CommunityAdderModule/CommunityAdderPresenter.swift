//
//  CommunityAdderPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 01..
//

import Foundation

class CommunityAdderPresenter: ObservableObject{
    private let interactor: CommunityAdderInteractor
    
    init(interactor: CommunityAdderInteractor){
        self.interactor = interactor
    }
    
    func addCommunity(name: String){
        interactor.addCommunity(name: name)
    }
    
}
