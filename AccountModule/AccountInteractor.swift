//
//  AccountInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 14..
//

import Foundation

class AccountInteractor{
    
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    func signOut(){
        model.signOut()
    }
    
    func currentUserEmail() -> String {
        return (model.auth.currentUser?.email)!
    }
}
