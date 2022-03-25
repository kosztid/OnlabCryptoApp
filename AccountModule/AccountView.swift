//
//  AccountView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 13..
//

import SwiftUI

struct AccountView: View {
    var presenter: AccountPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
            VStack{
                VStack(alignment:.center){
                    Text("Email address:")
                    Text(presenter.currentUserEmail())
                }
                .font(.system(size: 18))
                .foregroundColor(Color.theme.accentcolor)
                
                presenter.makeLogoutButton()
            }
            .padding(10)
        }.background(Color.theme.backgroundcolor)
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(presenter: AccountPresenter(interactor: AccountInteractor(model: DataModel())))
    }
}

