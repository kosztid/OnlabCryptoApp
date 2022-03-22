//
//  MessageBubble.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    var sender: String
    var body: some View {
        VStack(alignment: (message.sender == sender) ? .trailing : .leading){
            HStack{
                Text(message.message)
                    .padding(10)
                    .background((message.sender == sender) ? Color.theme.messagesent : Color.theme.messagereceived)
                    .cornerRadius(20)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor((message.sender == sender) ? Color.theme.backgroundcolor : Color.theme.accentcolor )
            }
            .frame(maxWidth: UIScreen.main.bounds.width*0.95, alignment: (message.sender == sender) ? .trailing : .leading)
        }.frame(maxWidth: .infinity)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "123", sender: "Dominik", message: "Tesztüzem", time: "2022-02-02", received: true), sender: "")
    }
}
