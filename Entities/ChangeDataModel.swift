//
//  ChangeDataModel.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 02..
//

import Foundation

struct ChangeDataModel: Identifiable, Codable{
    var id: String
    var coinid: String
    var price: Double
}
