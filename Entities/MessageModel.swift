//
//  Message.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation

struct MessageModel: Identifiable, Codable{
    var id: Int
    var sender: String
    var senderemail: String
    var message: String
    var time: String
    var image: Bool
}
