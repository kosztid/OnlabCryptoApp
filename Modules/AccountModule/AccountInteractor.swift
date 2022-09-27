//
//  AccountInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 14..
//

import Foundation

class AccountInteractor{
    
    private let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    func signOut(){
        try?model.auth.signOut()
        DispatchQueue.main.async {
            self.model.isSignedIn = false
            self.model.heldcoins = []
            self.model.favcoins = []
            self.model.ownedcoins = []
        }
    }
    
    func currentUserEmail() -> String {
        return (model.auth.currentUser?.email)!
    }
}
