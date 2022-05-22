//
//  CommunitiesListItem.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 11..
//

import SwiftUI

struct CommunitiesListItem: View {
    var community: MessageGroupModel
    var body: some View {
        ZStack{
            Color.theme.backgroundsecondary
                .ignoresSafeArea()
            
            HStack{
                Text(community.name)
                    .foregroundColor(Color.theme.accentcolor)
            }
        }
    }
}

struct CommunitiesListItem_Previews: PreviewProvider {
    static var previews: some View {
        CommunitiesListItem(community: MessageGroupModel(id: "1", name: "Bitcoin Community", messages:[MessageModel(id: "123", sender: "Dominik", senderemail: "mail", message: "Első üzenet", time: "2022-02-02", image: false),MessageModel(id: "124", sender: "Dominik",senderemail: "mail", message: "Második üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenet", time:"2022-02-02", image: false),MessageModel(id: "125", sender: "Dominik", senderemail: "email", message: "Harmadik üzenet", time: "2022-02-02", image: false)], members: ["szia"], lastid: "jasd"))
    }
}
