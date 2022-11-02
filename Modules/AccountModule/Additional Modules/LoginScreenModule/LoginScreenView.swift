import SwiftUI

struct LoginScreenView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var presenter: LoginScreenPresenter
    @State var email = ""
    @State var password = ""
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
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }.offset(x: -20)
                    }
                    signInButton
                    .alert("Wrong email-password", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {presenter.setlogerrorfalse() }
                    }
                    .accessibilityIdentifier("LoginButton")
                    HStack {
                        Spacer()
                        presenter.toRegisterView()
                        Spacer()
                        Button("Mégse") {
                            self.presentationMode.wrappedValue.dismiss()
                        }.foregroundColor(Color.theme.accentcolor)
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
            Label("", systemImage: "bitcoinsign.circle")
                .font(.system(size: 200))
                .foregroundColor(Color.theme.accentcolor)
            Text("Bejelentkezés")
                .font(.system(size: 50))
                .padding(10)
        }
    }

    var emailField: some View {
        TextField("Email", text: $email)
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(10)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .accessibilityIdentifier("LoginEmailTextField")
    }

    var securedPwField: some View {
        SecureField("Password", text: $password)
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(10)
            .disableAutocorrection(true)
            .accessibilityIdentifier("LoginPasswordTextField")
    }

    var nonsecuredPwField: some View {
        TextField("Password", text: $password)
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
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
            // self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Bejelentkezés")
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20))
                .background(Color.theme.backgroundsecondary)
                .foregroundColor(Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
}
