//
//  MessageGroup.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

struct MessageGroup: Identifiable, Codable{
    var id: String
    var name: String
    var messages: [Message]
    var members: [String]
    var lastid: String
}
