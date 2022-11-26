import SwiftUI

struct LoginScreenView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var presenter: LoginScreenPresenter
    @State var email = Strings.empty
    @State var password = Strings.empty
    @State private var isSecured = true
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundcolor.ignoresSafeArea(.all)

                VStack {
                    loginHeader
                    emailField
                    ZStack(alignment: .trailing) {
                        if isSecured {
                            securedPwField
                        } else {
                            nonsecuredPwField
                        }
                        eyeButton
                    }
                    signInButton
                        .alert(Strings.wrongCreds, isPresented: $showingAlert) {
                        Button(Strings.back, role: .cancel) {presenter.setlogerrorfalse() }
                    }
                    .accessibilityIdentifier("LoginButton")
                    HStack {
                        Spacer()
                        presenter.toRegisterView()
                        Spacer()
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text(Strings.return)
                                .frame(width: UIScreen.main.bounds.width * 0.3)
                        }
                        .buttonStyle(UnifiedBorderedButtonStyle())
                        Spacer()
                    }
                    .foregroundColor(Color.theme.accentcolor)
                }
                .padding(10)
            }
        }
        .onChange(of: presenter.loginerror) { _ in
            if presenter.loginerror == true {
                self.showingAlert = true
            }
        }
        .onChange(of: presenter.signedin) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
        .onAppear(perform: presenter.load)
        .navigationBarHidden(true)
        .background(Color.theme.backgroundcolor)
    }

    var loginHeader: some View {
        VStack {
            Image.bitcoinSign
                .font(.system(size: 200))
                .foregroundColor(Color.theme.accentcolor)
            Text(Strings.login)
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
            .accessibilityIdentifier("LoginEmailTextField")
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
            .accessibilityIdentifier("LoginPasswordTextField")
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

    var signInButton: some View {
        Button {
            guard presenter.isValidEmail(email: self.email), !self.password.isEmpty else {
                return
            }
            presenter.signIn(email: self.email, password: self.password)
        } label: {
            Text(Strings.login)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20))
        }
        .buttonStyle(UnifiedBorderedButtonStyle())
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
