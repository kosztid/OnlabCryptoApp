//
//  MessagerPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

class MessagerPresenter: ObservableObject{
    private let interactor: MessagerInteractor
    @Published var messagegroup: MessageGroup = MessageGroup(id: "111", name: "TesztCsoport", messages: [Message(id: "123", sender: "Dominik", message: "Első üzenet", time: Date(), received: true),Message(id: "124", sender: "Dominik", message: "Második üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenet", time: Date(), received: false),Message(id: "125", sender: "Dominik", message: "Harmadik üzenet", time: Date(), received: true)])
    
    init(interactor: MessagerInteractor){
        self.interactor = interactor
    }
    func sendmessage(message: String){
        messagegroup.messages.append(Message(id: "999", sender: "Dominik", message: message, time: Date(), received: false))
    }
    func messagesGet() -> [Message] {
        return messagegroup.messages
    }
}
