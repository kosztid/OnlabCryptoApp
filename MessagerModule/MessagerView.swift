//
//  MessagerView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import SwiftUI
import simd

struct MessagerView: View {
    @ObservedObject var presenter: MessagerPresenter
    @State var newmessage: String = ""
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack{
                ScrollViewReader{ proxy in
                    ScrollView{
                        ForEach(presenter.community.messages){ message in
                            ZStack{
                                Color.theme.backgroundcolor
                                        .ignoresSafeArea()
                                MessageBubble(message: message,sender: presenter.getAccountInfo())
                            }
                            
                        }
                    }
                    .onChange(of: presenter.community.lastid, perform: { id in
                        withAnimation{
                            DispatchQueue.main.async {
                            proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    })
                    .onAppear(perform: {
                        withAnimation{
                            DispatchQueue.main.async {
                                proxy.scrollTo(presenter.community.lastid, anchor: .bottom)
                            }
                        }
                    })
                
                }
                
                ZStack(alignment: .trailing){
                    Color.theme.textbox
                    TextField("Type in a new message", text: $newmessage)
                        .background(Color.theme.textbox)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                        .disableAutocorrection(true)
                        .frame(height: 40,alignment: .center)
                        .padding(10)
                        .disabled(presenter.issignedin() == false)
                        
                    
                    Button(action: {
                        if presenter.issignedin() == true {
                            presenter.sendmessage(message: newmessage)
                            newmessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane")
                            .accentColor(Color.theme.accentcolorsecondary)
                            .font(.system(size: 18))
                    }.offset(x: -20)
                }.frame(height: 40)
                    .cornerRadius(20)
                    .padding(10)
                    
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                        presenter.makeButtonForUsers()
                }
            }
        }
    }
}

struct MessagerView_Previews: PreviewProvider {
    static var previews: some View {
        MessagerView(presenter: MessagerPresenter(interactor: MessagerInteractor(model: DataModel()),community: MessageGroup(id: "1", name: "Bitcoin Community", messages:[Message(id: "123", sender: "Dominik", senderemail: "email", message: "Első üzenet", time: "2022-02-02 10:00:00"),Message(id: "124", sender: "Dominik", senderemail: "email", message: "Második üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenet", time: "2022-02-02 10:00:00"),Message(id: "125", sender: "Dominik", senderemail: "email", message: "Harmadik üzenet", time: "2022-02-02")], members: ["Szia"], lastid: "jasd")),newmessage: "Újüzenet")
    }
}
