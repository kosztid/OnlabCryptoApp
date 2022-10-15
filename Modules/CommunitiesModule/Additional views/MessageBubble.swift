//
//  MessageBubble.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import SwiftUI

struct MessageBubble: View {
    var message: MessageModel
    var sender: String
    var body: some View {
        VStack(alignment: (message.sender == sender) ? .trailing : .leading) {
            if message.image == true {
                HStack {
                    CachedAsyncImage(url: URL(string: message.message )) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .frame(width: UIScreen.main.bounds.width*0.95)
                    }
                    .frame(width: UIScreen.main.bounds.width*0.8)
                    .cornerRadius(10)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.95, alignment: (message.sender == sender) ? .trailing : .leading)
            } else {
                HStack {
                    Text(message.message)
                        .padding(10)
                        .background((message.sender == sender) ? Color.theme.messagesent : Color.theme.messagereceived)
                        .cornerRadius(20)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor((message.sender == sender) ? Color.theme.backgroundcolor : Color.theme.accentcolor )
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.95, alignment: (message.sender == sender) ? .trailing : .leading)
            }
        }.frame(maxWidth: .infinity)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: MessageModel(id: 123, sender: "Dominik", senderemail: "mail", message: "Tesztüzem", time: "2022-02-02", image: false), sender: "")
    }
}
