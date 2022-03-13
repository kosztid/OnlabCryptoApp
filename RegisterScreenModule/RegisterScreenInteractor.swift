//
//  RegisterScreenInteractor.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation

class RegisterScreenInteractor {
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    func register(email: String, password: String){
        model.register(email: email, password: password)
    }
}
