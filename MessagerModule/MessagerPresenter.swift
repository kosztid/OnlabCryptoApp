//
//  MessagerPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

class MessagerPresenter: ObservableObject{
    private let interactor: MessagerInteractor
    @Published var community: MessageGroup
    
    init(interactor: MessagerInteractor,community: MessageGroup ){
        self.interactor = interactor
        self.community = community
    }
    func sendmessage(message: String){
        community.messages.append(Message(id: "999", sender: "Dominik", message: message, time: Date(), received: false))
    }
    func messagesGet() -> [Message] {
        return community.messages
    }
}
