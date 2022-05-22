//
//  MessagerInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation
import UIKit

class MessagerInteractor{
    private let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    func sendMessage(id: String, message: MessageModel){
        if id != "CbP9VCE4TWEHftzZuL4Q" {
            model.sendMessage(id:id,message: message)
        }
    }
    func getmodel() -> DataModel {
        return model
    }
    func getAccountInfo() -> String{
        return model.auth.currentUser?.uid ?? "nouser"
    }
    func getAccountEmail() -> String{
        return model.auth.currentUser?.email ?? "nouser"
    }
    func addUser(id: String, user: String){
        model.addCommunityMember(id: id, member: user)
    }
    func issignedin() -> Bool {
        return model.isSignedIn
    }
    func sendPhoto(image:UIImage, message: MessageModel,id: String){
        model.sendPhoto(image: image, message: message, communityid: id)
    }
        
}
