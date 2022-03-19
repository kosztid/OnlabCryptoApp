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
                    HStack{
                        Spacer()
                        Button{
                            presenter.changeViewTo(viewname: "portfolio")
                        }
                    label: {
                       Text("Portfolio")
                           .frame(height:30)
                           .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                           .font(.system(size: 20))
                           .background(presenter.isSelected(selected: "portfolio") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                           .foregroundColor(presenter.isSelected(selected: "portfolio") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                           .cornerRadius(10)
                   }
                        Button{
                            presenter.changeViewTo(viewname: "favfolio")
                        } label: {
                            Text("Favorites")
                                .frame(height:30)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                                .font(.system(size: 20))
                                .background(presenter.isSelected(selected: "favfolio") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                                .foregroundColor(presenter.isSelected(selected: "favfolio") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                                .cornerRadius(10)
                        }
                    Spacer()
                    }.padding(5)
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
