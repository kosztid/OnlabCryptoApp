//
//  Message.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

struct Message: Identifiable, Codable{
    var id: String
    var sender: String
    var message: String
    var time: String
}
