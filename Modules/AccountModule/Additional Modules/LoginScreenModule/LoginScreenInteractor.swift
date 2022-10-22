//
//  LoginScreenInteractor.swift
//  Onlab
//
//  Created by Kosztolánczi Dominik on 2022. 02. 22..
//

import Foundation

class LoginScreenInteractor {
    private let userService: UserService

    init() {
        userService = UserService()
        userService.userReload()
    }
    func signIn(email: String, password: String) {
        userService.signin(email, password)
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }
    
    func getLoginError() -> Published<Bool>.Publisher {
        return userService.$loginError
    }

    func setlogerrorfalse() {
        userService.loginError = false
    }
}
