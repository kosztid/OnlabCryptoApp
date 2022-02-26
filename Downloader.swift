//
//  Downloader.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import Combine

class Downloader{
    @Published var allcoins: [CoinModel] = []
    
    var coinsub: AnyCancellable?
    init (){
        
    }
    
    
}
