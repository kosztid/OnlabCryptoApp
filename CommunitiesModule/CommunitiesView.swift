//
//  CommunitiesView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

struct CommunitiesView: View {
    @ObservedObject var presenter: CommunitiesPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            
            List{
                ForEach(presenter.communities){ community in
                    ZStack{
                        Color.theme.backgroundcolor
                            .ignoresSafeArea()
                        CommunitiesListItem(community: community)
                            .frame(height: 60)
                            .cornerRadius(10)
                            .padding(5)
                        self.presenter.linkBuilder(for: community){
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
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
            .listStyle(PlainListStyle())
        }
    }
}

struct CommunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = CommunitiesInteractor(model: model)
        let presenter = CommunitiesPresenter(interactor: interactor)
        CommunitiesView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
