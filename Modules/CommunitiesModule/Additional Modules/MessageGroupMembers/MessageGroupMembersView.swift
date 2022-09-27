//
//  MessageGroupMembersView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 04. 13..
//

import SwiftUI

struct MessageGroupMembersView: View {
    @ObservedObject var presenter: MessageGroupMembersPresenter
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                Text("Members of the Group")
                    .font(.system(size: 20))
                List {
                    ForEach(presenter.community.members, id:\.self){ member in
                        ZStack{
                            Color.theme.backgroundcolor
                                .ignoresSafeArea()
                            Text(member)   
                        }
                    }
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}
/*
struct MessageGroupMembersView_Previews: PreviewProvider {
    static var previews: some View {
        MessageGroupMembersView()
    }
}
*/
