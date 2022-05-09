//
//  LoginScreenPresenter.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation
import SwiftUI
import Combine

class LoginScreenPresenter: ObservableObject{
    private let interactor: LoginScreenInteractor
    private let router = LoginScreenRouter()
    @Published var signedin : Bool = false
    @Published var loginerror : Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: LoginScreenInteractor){
        self.interactor = interactor
        
        interactor.model.$isSignedIn
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)
        
        interactor.model.$loginerror
            .assign(to: \.loginerror, on: self)
            .store(in: &cancellables)
    }
    
    func signIn(email: String, password: String){
        return interactor.signIn(email: email, password: password)
    }
    func twittersignIn(){
      //  interactor.twittersignIn()
    }
    func setlogerrorfalse(){
        interactor.setlogerrorfalse()
    }
    
    func toRegisterView() -> some View{
        NavigationLink("Regisztráció", destination: router.makeRegisterView(model: interactor.model))
    }
    
    func toForgotPasswordView() -> some View{
        NavigationLink("Elfelejtett jelszó",destination: Text("elfejeletett pw"))
    }
    func isValidEmail(email: String) -> Bool {
        let emailto = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailto.evaluate(with: email)
    }
}
