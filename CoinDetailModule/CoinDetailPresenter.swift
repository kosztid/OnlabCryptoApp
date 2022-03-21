//
//  CoinDetailPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI

class CoinDetailPresenter: ObservableObject{
    @State var showalert : Bool = false
    private let interactor: CoinDetailInteractor
    private let router = CoinDetailRouter()
    
    init(interactor: CoinDetailInteractor){
        self.interactor = interactor
    }
    
    func values() -> [CGFloat]{
        return interactor.getvalues()
    }
    func getcoin() -> CoinModel{
        return interactor.getcoin()
    }
    func getmodel() -> DataModel{
        return interactor.getmodel()
    }
    /*
    func detailed() -> CoinDetailModel{
        return interactor.getcoindetail()
    }
    
     */
    func makeButtonForPortfolioAdderView() -> some View {
        var buttontext: String
        if interactor.held() {
            buttontext = "Edit"
        }
        else {
            buttontext = "Add"
        }
        return NavigationLink(buttontext, destination: router.makeAdderView(coincount: interactor.getCoinCount(), coin:interactor.getcoin(), model: interactor.getmodel()))
    }
    
    func makeFavButton() -> some View {
        Button(){
            self.interactor.addFavCoin()
        } label: {
            Label("",systemImage: interactor.isFav() ? "star.fill" : "star")
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 25))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    func makeAddButton() -> some View{
        Button("ADD"){
            self.showalert = true
        }
        .alert(isPresented:$showalert){
            Alert(title: Text("Add"), message: Text("type in the amount"), primaryButton: .destructive(Text("Add")){}, secondaryButton: .cancel())
        }
    }
}
