//
//  PortfolioView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var presenter: PortfolioPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            
            VStack{
                VStack{
                    Text("Portfolio Total:")
                    Text("\(presenter.portfoliototal().formatcurrency4digits())")
                    Button("VÁLTÁS"){
                        presenter.changeView()
                    }
                }
                presenter.makeList(selected: presenter.selection)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if presenter.signedin {
                            presenter.makeButtonForAccount()
                        } else {
                            presenter.makeButtonForLogin()
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = PortfolioInteractor(model: model)
        let presenter = PortfolioPresenter(interactor: interactor)
        PortfolioView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
