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
                    HStack{
                        VStack{
                            HStack{
                                Spacer()
                                Text("Portfolio Total:")
                                    .font(.system(size: 20))
                                Spacer()
                                HStack{
                                    VStack{
                                        Text("\(presenter.portfoliototal().formatcurrency4digits())")
                                            .font(.system(size: 20))
                                            .frame(alignment:.leading)
                                        Text("\(presenter.inputtotal().formatcurrency4digits())")
                                            .foregroundColor(Color.theme.accentcolorsecondary)
                                            .font(.system(size: 18))
                                            .frame(alignment:.leading)
                                    }.frame(alignment:.leading)
                                    VStack{
                                        HStack{
                                            Text("\(presenter.winlosepercent().formatpercent())")
                                                .foregroundColor((presenter.winlosepercent() >= 0) ? Color.theme.green : Color.theme.red )
                                                .frame(alignment:.leading)
                                            Spacer()
                                        }
                                    }
                                
                                }
                                Spacer()
                            }.padding(5)
                            
                        }.frame(alignment:.leading)
                    }.padding(10)
                        .foregroundColor(Color.theme.accentcolor)
                    HStack{
                        Spacer()
                        presenter.makeButtonforPortfolioList()
                        presenter.makeButtonforFavfolioList()
                    Spacer()
                    }
                    Spacer()
                }
                .padding(5)
                .frame(alignment: .leading)
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
