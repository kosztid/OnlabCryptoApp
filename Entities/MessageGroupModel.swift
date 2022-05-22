//
//  MessageGroup.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

struct MessageGroupModel: Identifiable, Codable{
    var id: String
    var name: String
    var messages: [MessageModel]
    var members: [String]
    var lastid: String
}
