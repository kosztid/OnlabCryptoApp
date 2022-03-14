//
//  AccountViewPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 14..
//

import Foundation

class AccountPresenter{
    private let interactor: AccountInteractor
    
    init(interactor: AccountInteractor){
        self.interactor = interactor
    }
    
    func signOut(){
        interactor.signOut()
    }
}
