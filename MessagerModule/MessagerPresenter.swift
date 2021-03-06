//
//  MessagerPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation
import SwiftUI

class MessagerPresenter: ObservableObject{
    private let interactor: MessagerInteractor
    @Published var community: MessageGroupModel
    private let router = MessagerRouter()
    
    
    init(interactor: MessagerInteractor,community: MessageGroupModel ){
        self.interactor = interactor
        self.community = community
    }
    func sendmessage(message: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringdate = dateFormatter.string(from: Date())
        let email = interactor.getAccountEmail()
        self.interactor.sendMessage(id: community.id,message: MessageModel(id:"1", sender: interactor.getAccountInfo(), senderemail: email, message: message, time: stringdate, image: false))
        self.interactor.addUser(id: self.community.id, user: email)
    }
    func messagesGet() -> [MessageModel] {
        return community.messages
    }
    func getAccountInfo() -> String{
        return interactor.getAccountInfo()
    }
    func issignedin() -> Bool {
        return interactor.issignedin()
    }
    func usersGet() -> [String]{
        return community.members
    }
    func makeButtonForUsers() -> some View{
        NavigationLink("Members", destination: router.makeMembersView(model: interactor.getmodel(), community: self.community))
    }
    func sendPhoto(image:UIImage){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringdate = dateFormatter.string(from: Date())
        let email = interactor.getAccountEmail()
        interactor.sendPhoto(image: image, message: MessageModel(id:"1", sender: interactor.getAccountInfo(), senderemail: email, message: "lateinit mail", time: stringdate, image: true), id: community.id)
    }
}
