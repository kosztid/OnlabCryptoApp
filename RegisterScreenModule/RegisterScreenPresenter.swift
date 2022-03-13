//
//  RegisterScreenPresenter.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation


class RegisterScreenPresenter: ObservableObject{
    private let interactor: RegisterScreenInteractor
    
    init(interactor: RegisterScreenInteractor){
        self.interactor = interactor
    }
    
    func register(email: String, password: String){
        interactor.register(email: email, password: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailto = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailto.evaluate(with: email)
    }
}
