//
//  LoginScreenRouter.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation
import SwiftUI

class LoginScreenRouter{
    
    func makeRegisterView(model: DataModel) -> some View{
        let presenter = RegisterScreenPresenter(interactor: RegisterScreenInteractor(model: model))
        return RegisterScreenView(presenter: presenter)
    }
}
