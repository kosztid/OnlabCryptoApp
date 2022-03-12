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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let stringdate = dateFormatter.string(from: Date())
        self.interactor.sendMessage(id: community.id,message: Message(id:"asd", sender: "Dominik", message: message, time: stringdate,received: false))
    }
    func messagesGet() -> [Message] {
        return community.messages
    }
}
