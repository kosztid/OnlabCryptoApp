import simd
import SwiftUI

struct MessagerView: View {
    @ObservedObject var presenter: MessagerPresenter
    @State var newmessage: String = Strings.empty
    @State var showImagePicker = false
    @State var image: UIImage?

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                ScrollViewReader { proxy in
                    // swiftlint:disable:next trailing_closure
                    ScrollView {
                        messageBubbles
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
                messagingBar
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

    var messageBubbles: some View {
        ForEach(presenter.community.messages) { message in
            ZStack {
                Color.theme.backgroundcolor
                    .ignoresSafeArea()
                MessageBubble(message: message, sender: presenter.getAccountInfo())
            }
        }
    }

    var messagingBar: some View {
        ZStack(alignment: .trailing) {
            Color.theme.textbox
            messageTextField
                .accessibilityIdentifier("MessageTextfield")
            Button {
                showImagePicker.toggle()
            } label: {
                if self.image == nil {
                    Image.photo
                } else {
                    Image.photoFill
                }
            }
            .accentColor(Color.theme.accentcolorsecondary)
            .font(.system(size: 18))
            .offset(x: -(UIScreen.main.bounds.width * 0.15))
            messageSendButton
                .accessibilityIdentifier("MessageSendButton")
        }
        .frame(height: 40)
        .cornerRadius(20)
        .padding(10)
    }
    var messageTextField: some View {
        TextField(Strings.newMessage, text: $newmessage)
            .background(Color.theme.textbox)
            .foregroundColor(Color.black)
            .font(.system(size: 20))
            .disableAutocorrection(true)
            .frame(height: 40, alignment: .center)
            .padding(10)
            .disabled(presenter.issignedin() == false)
    }

    var messageSendButton: some View {
        Button(action: {
            print(presenter.issignedin())
            if presenter.issignedin() == true {
                if self.image != nil {
                    presenter.sendPhoto(image: self.image!)
                    self.image = nil
                }
                if !newmessage.isEmpty {
                    presenter.sendmessage(message: newmessage)
                }
                newmessage = Strings.empty
            }
        }) {
            Image.paperplane
                .accentColor(Color.theme.accentcolorsecondary)
                .font(.system(size: 18))
        }.offset(x: -(UIScreen.main.bounds.width * 0.05))
    }
}
