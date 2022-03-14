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
                Text("Account")
                    .foregroundColor(Color.theme.accentcolor)
                Button("LogOut"){
                    presenter.signOut()
                }
            }
        }
        
    }
}
/*
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
*/
