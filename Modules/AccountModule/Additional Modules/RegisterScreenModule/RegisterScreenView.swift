import SwiftUI

struct RegisterScreenView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var presenter: RegisterScreenPresenter
    @State var email = ""
    @State var password = ""
    @State var isSecured = true
    @State private var showingAlert = false

    var body: some View {
        ScrollView {
            VStack {
                registrationHeader
                emailField

                ZStack(alignment: .trailing) {
                    if isSecured {
                        securedPwField
                    } else {
                        nonsecuredPwField
                    }
                    eyeButton
                }

                Button {
                    guard presenter.isValidEmail(email: self.email), self.password.count > 5 else {
                        return
                    }
                    presenter.register(email: self.email, password: self.password)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Fiók létrehozása")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                }
                .buttonStyle(UnifiedBorderedButtonStyle())
                .alert(Strings.wrongRegCreds, isPresented: $showingAlert) {
                    Button(Strings.back, role: .cancel) {presenter.setregistererrorfalse() }
                }
            }
            .padding(10)
        }
        .onChange(of: presenter.registererror) { _ in
            if presenter.registererror == true {
                self.showingAlert = true
            }
        }
        .onChange(of: presenter.registered) { _ in
            self.presentationMode.wrappedValue.dismiss()
            presenter.setregisteredfalse()
        }
        .onAppear(perform: presenter.load)
        .navigationTitle(Strings.registration)
        .background(Color.theme.backgroundcolor)
    }

    var registrationHeader: some View {
        VStack {
            Image.network
                .font(.system(size: 200))
                .foregroundColor(Color.theme.accentcolor)
            Text(Strings.registration)
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 50))
                .padding(10)
        }
    }

    var emailField: some View {
        TextField("", text: $email)
            .placeholder(when: email.isEmpty) {
                Text(Strings.email).foregroundColor(.gray)
            }
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .foregroundColor(Color.theme.accentcolor)
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(10)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }

    var securedPwField: some View {
        SecureField("", text: $password)
            .placeholder(when: password.isEmpty) {
                Text(Strings.password).foregroundColor(.gray)
            }
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .foregroundColor(Color.theme.accentcolor)
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(10)
            .disableAutocorrection(true)
    }

    var nonsecuredPwField: some View {
        TextField("", text: $password)
            .placeholder(when: password.isEmpty) {
                Text(Strings.password).foregroundColor(.gray)
            }
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .foregroundColor(Color.theme.accentcolor)
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(10)
            .disableAutocorrection(true)
    }

    var eyeButton: some View {
        Button(action: {
            isSecured.toggle()
        }) {
            if self.isSecured {
                Image.eyeSlash
                    .foregroundColor(Color.theme.accentcolorsecondary)
            } else {
                Image.eye
                    .foregroundColor(Color.theme.accentcolorsecondary)
            }
        }.offset(x: -20)
    }
}
