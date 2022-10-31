import SwiftUI
import simd

struct MessagerView: View {
    @ObservedObject var presenter: MessagerPresenter
    @State var newmessage: String = ""
    @State var showImagePicker = false
    @State var image: UIImage?

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(presenter.community.messages) { message in
                            ZStack {
                                Color.theme.backgroundcolor
                                    .ignoresSafeArea()
                                MessageBubble(message: message, sender: presenter.getAccountInfo())
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
                        .frame(height: 40, alignment: .center)
                        .padding(10)
                        .disabled(presenter.issignedin() == false)
                        .accessibilityIdentifier("MessageTextfield")
                    if self.image == nil {
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            Image(systemName: "photo")
                                .accentColor(Color.theme.accentcolorsecondary)
                                .font(.system(size: 18))
                        }.offset(x: -(UIScreen.main.bounds.width * 0.15))
                    } else {
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            Image(systemName: "photo.fill")
                                .accentColor(Color.theme.accentcolorsecondary)
                                .font(.system(size: 18))
                        }.offset(x: -(UIScreen.main.bounds.width * 0.15))
                    }
                    Button(action: {
                        if presenter.issignedin() == true {
                            if self.image != nil {
                                presenter.sendPhoto(image: self.image!)
                                self.image = nil
                            }
                            if newmessage.isEmpty {
                                presenter.sendmessage(message: newmessage)
                            }
                            newmessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane")
                            .accentColor(Color.theme.accentcolorsecondary)
                            .font(.system(size: 18))
                    }.offset(x: -(UIScreen.main.bounds.width * 0.05))
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
        }.fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}
