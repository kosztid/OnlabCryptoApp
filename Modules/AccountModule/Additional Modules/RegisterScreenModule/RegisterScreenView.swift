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
                    Button(action: {
                        isSecured.toggle()
                    }) {
                        Image(systemName: self.isSecured ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }.offset(x: -20)
                }

                Button {
                    guard presenter.isValidEmail(email: self.email), self.password.count > 5 else {
                        return
                    }
                    presenter.register(email: self.email, password: self.password)
                } label: {
                    Text("Fiók létrehozása")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .background(Color.theme.backgroundsecondary)
                        .foregroundColor(Color.theme.accentcolor)
                        .cornerRadius(10)
                }
                .alert("Email already registered/password shorter than 6 characters", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {presenter.setregistererrorfalse() }
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
        .navigationTitle("Regisztráció")
        .background(Color.theme.backgroundcolor)
    }

    var registrationHeader: some View {
        VStack {
            Label("", systemImage: "network")
                .font(.system(size: 200))
                .foregroundColor(Color.theme.accentcolor)
            Text("Regisztráció")
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
    }

    var securedPwField: some View {
        SecureField("Password", text: $password)
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(10)
            .disableAutocorrection(true)
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
}
