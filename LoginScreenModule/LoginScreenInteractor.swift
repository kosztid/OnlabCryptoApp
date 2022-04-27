//
//  LoginScreenInteractor.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation

class LoginScreenInteractor {
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    func signIn(email: String, password: String){
        model.signIn(email: email, password: password)
    }
}
