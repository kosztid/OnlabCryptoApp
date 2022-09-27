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
    @State var showImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack{
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(presenter.community.messages){ message in
                            ZStack {
                                Color.theme.backgroundcolor
                                        .ignoresSafeArea()
                                MessageBubble(message: message,sender: presenter.getAccountInfo())
                            }
                            
                        }
                    }
                    .onChange(of: presenter.community.lastid, perform: { id in
                        withAnimation {
                            DispatchQueue.main.async {
                            proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    })
                    .onAppear(perform: {
                        withAnimation {
                            DispatchQueue.main.async {
                                proxy.scrollTo(presenter.community.lastid, anchor: .bottom)
                            }
                        }
                    })
                }
                ZStack(alignment: .trailing) {
                    Color.theme.textbox
                    TextField("Type in a new message", text: $newmessage)
                        .background(Color.theme.textbox)
                        .foregroundColor(Color.black)
                        .font(.system(size: 20))
                        .disableAutocorrection(true)
                        .frame(height: 40,alignment: .center)
                        .padding(10)
                        .disabled(presenter.issignedin() == false)
                        .accessibilityIdentifier("MessageTextfield")
                    
                    if self.image == nil {
                        Button{showImagePicker.toggle()
                            
                        }label:{
                            Image(systemName: "photo")
                                .accentColor(Color.theme.accentcolorsecondary)
                                .font(.system(size: 18))
                        }.offset(x: -(UIScreen.main.bounds.width*0.15))
                        
                    } else {
                        Button{showImagePicker.toggle()
                        }label:{
                            Image(systemName: "photo.fill")
                                .accentColor(Color.theme.accentcolorsecondary)
                                .font(.system(size: 18))
                        }.offset(x: -(UIScreen.main.bounds.width*0.15))
                    }
                    Button(action: {
                        if presenter.issignedin() == true {
                            if self.image != nil {
                                presenter.sendPhoto(image: self.image!)
                                self.image = nil
                            }
                            if newmessage != "" {
                                presenter.sendmessage(message: newmessage)
                            }
                            newmessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane")
                            .accentColor(Color.theme.accentcolorsecondary)
                            .font(.system(size: 18))
                    }.offset(x: -(UIScreen.main.bounds.width*0.05))
                        .accessibilityIdentifier("MessageSendButton")
                }.frame(height: 40)
                    .cornerRadius(20)
                    .padding(10)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        presenter.makeButtonForUsers()
                        .accessibilityIdentifier("MessageMembersButton")
                }
            }
        }.fullScreenCover(isPresented: $showImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
    }
}

struct MessagerView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        MessagerView(presenter: MessagerPresenter(interactor: MessagerInteractor(model: DataModel()),community: MessageGroupModel(id: "1", name: "Bitcoin Community", messages:[MessageModel(id: 123, sender: "Dominik", senderemail: "email", message: "Első üzenet", time: "2022-02-02 10:00:00", image: false),MessageModel(id: 1241, sender: "Dominik", senderemail: "email", message: "Második üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenet", time: "2022-02-02 10:00:00", image: false),MessageModel(id: 125, sender: "Dominik", senderemail: "email", message: "Harmadik üzenet", time: "2022-02-02", image: false)], members: ["Szia"], lastid: 1)),newmessage: "Újüzenet")
    }
}
