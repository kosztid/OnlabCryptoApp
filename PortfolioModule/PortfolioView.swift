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
                    VStack{
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    HStack{
                                        Text("Portfolio Total:")
                                            .font(.system(size: 20))
                                        Spacer()
                                        Text("\(presenter.portfoliototal().formatcurrency4digits())")
                                            .font(.system(size: 20))
                                            .frame(alignment:.leading)
                                    }
                                    HStack{
                                        Text("Portfolio invested:")
                                            .font(.system(size: 18))
                                        Spacer()
                                        Text("\(presenter.portfoliobuytotal().formatcurrency4digits())")
                                            .foregroundColor(Color.theme.accentcolorsecondary)
                                            .font(.system(size: 18))
                                            .frame(alignment:.leading)
                                    }
                                }.frame(width:UIScreen.main.bounds.width*0.75)
                                Spacer()
                                Text("\(presenter.winlosepercent().formatpercent())")
                                    .foregroundColor((presenter.winlosepercent() >= 0) ? Color.theme.green : Color.theme.red )
                                    .frame(alignment:.leading)
                                Spacer()
                            }
                        }
                    }
                    HStack{
                        Spacer()
                        presenter.makeButtonforPortfolioList()
                        presenter.makeButtonforFavfolioList()
                        Spacer()
                    }
                }
                .padding(.horizontal,5)
                .frame(height: 100,alignment: .leading)
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
