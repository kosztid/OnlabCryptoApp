//
//  MessagerView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import SwiftUI

struct MessagerView: View {
    @ObservedObject var presenter: MessagerPresenter
    @State var newmessage: String = ""
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack{
                ScrollView{
                    ForEach(presenter.messagesGet()){ message in
                        ZStack{
                            Color.theme.backgroundcolor
                                    .ignoresSafeArea()
                            MessageBubble(message: message)
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
                ZStack(alignment: .trailing){
                    Color.gray
                    TextField("Type in a new message", text: $newmessage)
                        .background(Color.gray)
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 20))
                        
                        .frame(height: 40,alignment: .center)
                        .padding(10)
                        
                    
                    Button(action: {
                        presenter.sendmessage(message: newmessage)
                        newmessage = ""
                    }) {
                        Image(systemName: "paperplane")
                            .accentColor(.blue)
                            .font(.system(size: 18))
                    }.offset(x: -20)
                }.frame(height: 40)
                    .cornerRadius(20)
                    .padding(10)
                    
            }
        }
    }
}

struct MessagerView_Previews: PreviewProvider {
    static var previews: some View {
        MessagerView(presenter: MessagerPresenter(interactor: MessagerInteractor(model: DataModel()),community: MessageGroup(id: "1", name: "Bitcoin Community", messages:[Message(id: "123", sender: "Dominik", message: "Első üzenet", time: "2022-02-02", received: true),Message(id: "124", sender: "Dominik", message: "Második üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenet", time: "2022-02-02", received: false),Message(id: "125", sender: "Dominik", message: "Harmadik üzenet", time: "2022-02-02", received: true)])),newmessage: "Újüzenet")
    }
}
