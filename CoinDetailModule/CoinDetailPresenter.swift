//
//  CoinDetailPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI

class CoinDetailPresenter: ObservableObject{
    private let interactor: CoinDetailInteractor
    
    init(interactor: CoinDetailInteractor){
        self.interactor = interactor
    }
    
    func values() -> [CGFloat]{
        return interactor.getvalues()
    }
    func coin() -> CoinModel{
        return interactor.coin
    }
    /*
    func detailed() -> CoinDetailModel{
        return interactor.getcoindetail()
    }
    
     */
}
