//
//  RegisterScreenPresenter.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation
import Combine

class RegisterScreenPresenter: ObservableObject{
    private let interactor: RegisterScreenInteractor
    
    @Published var registererror : Bool = false
    @Published var registered : Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: RegisterScreenInteractor){
        self.interactor = interactor
        interactor.model.$registererror
            .assign(to: \.registererror, on: self)
            .store(in: &cancellables)
        
        interactor.model.$registered
            .assign(to: \.registered, on: self)
            .store(in: &cancellables)
    }
    
    func register(email: String, password: String){
        interactor.register(email: email, password: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailto = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailto.evaluate(with: email)
    }
    func setregistererrorfalse(){
        interactor.setregistererrorfalse()
    }
    func setregisteredfalse(){
        interactor.setregisteredfalse()
    }
}
