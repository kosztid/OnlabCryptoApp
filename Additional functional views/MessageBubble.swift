//
//  MessageBubble.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing){
            HStack{
                Text(message.message)
                    .padding(10)
                    .background(Color.theme.backgroundsecondary)
                    .cornerRadius(20)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.theme.accentcolor)
            }
            .frame(maxWidth: UIScreen.main.bounds.width*0.95, alignment: message.received ? .leading : .trailing)
        }.frame(maxWidth: .infinity)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "123", sender: "Dominik", message: "Tesztüzem", time: Date(), received: true))
    }
}
