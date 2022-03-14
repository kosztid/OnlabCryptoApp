//
//  RegisterScreenView.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import SwiftUI

struct RegisterScreenView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var presenter: RegisterScreenPresenter
    @State var email : String = ""
    @State var password : String = ""
    @State var isSecured: Bool = true
    var body: some View {
        ScrollView {
            VStack{
                Label("",systemImage: "network")
                    .font(.system(size: 200))
                    .foregroundColor(Color.theme.accentcolor)
                Text("Regisztráció")
                    .font(.system(size: 50))
                    .padding(10)
                TextField("Email", text: $email)
                    .padding(.horizontal)
                    .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 20))
                    .background(Color.theme.backgroundsecondary)
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                ZStack(alignment: .trailing) {
                            if isSecured {
                                SecureField("Password", text: $password)
                                    .padding(.horizontal)
                                    .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .font(.system(size: 20))
                                    .background(Color.theme.backgroundsecondary)
                                    .cornerRadius(10)
                                    .disableAutocorrection(true)
                            } else {
                                TextField("Password", text: $password)
                                    .padding(.horizontal)
                                    .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .font(.system(size: 20))
                                    .background(Color.theme.backgroundsecondary)
                                    .cornerRadius(10)
                                    .disableAutocorrection(true)
                            }
                            Button(action: {
                                isSecured.toggle()
                            }) {
                                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                    .accentColor(.gray)
                            }.offset(x: -20)
                        }

                Button{
                    guard presenter.isValidEmail(email: self.email), self.password.count > 5 else {
                        return
                    }
                    presenter.register(email: self.email, password: self.password)
                    presentationMode.wrappedValue.dismiss()
                } label : {
                    Text("Fiók létrehozása")
                        .frame(height:50)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .background(Color.theme.backgroundsecondary)
                        .foregroundColor(Color.theme.accentcolor)
                        .cornerRadius(10)
                }
            }
            .padding(10)
        }
        .navigationTitle("Regisztráció")
        .background(Color.theme.backgroundcolor)
    }
}

struct RegisterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterScreenView(presenter: RegisterScreenPresenter(interactor: RegisterScreenInteractor(model: DataModel())))
    }
}
