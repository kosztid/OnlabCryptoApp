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
    @Published var community: MessageGroup
    
    init(interactor: MessagerInteractor,community: MessageGroup ){
        self.interactor = interactor
        self.community = community
    }
    func sendmessage(message: String){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringdate = dateFormatter.string(from: Date())
        self.interactor.sendMessage(id: community.id,message: Message(id:"1", sender: interactor.getAccountInfo(), message: message, time: stringdate))
    }
    func messagesGet() -> [Message] {
        return community.messages
    }
    func getAccountInfo() -> String{
        return interactor.getAccountInfo()
    }
    func issignedin() -> Bool {
        return interactor.issignedin()
    }
    func makeButtonForUsers() -> some View{
        NavigationLink("Members", destination: Text("Members"))
    }
}
