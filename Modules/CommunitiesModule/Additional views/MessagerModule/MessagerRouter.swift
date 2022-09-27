//
//  MessagerRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 05..
//

import Foundation
import SwiftUI
class MessagerRouter {
    func makeMembersView(model: DataModel,community: MessageGroupModel) -> some View {
        let presenter = MessageGroupMembersPresenter(interactor: MessageGroupMembersInteractor(model: model), community: community)
        return MessageGroupMembersView(presenter: presenter)
    }
}
