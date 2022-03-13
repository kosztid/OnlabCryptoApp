//
//  AccountView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 13..
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
            Text("Account")
                .foregroundColor(Color.theme.accentcolor)
        }
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
