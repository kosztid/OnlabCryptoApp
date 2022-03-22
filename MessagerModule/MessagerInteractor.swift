//
//  MessagerInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

class MessagerInteractor{
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    func sendMessage(id: String, message: Message){
        model.sendMessage(id:id,message: message)
    }
    func getAccountInfo() -> String{
        return model.auth.currentUser?.uid ?? "nouser"
    }
    
    func issignedin() -> Bool {
        return model.isSignedIn
    }
}
