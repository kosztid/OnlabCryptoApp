//
//  MessageGroupMembersPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 04. 13..
//

import Foundation

class MessageGroupMembersPresenter: ObservableObject {
    private let interactor: MessageGroupMembersInteractor
    @Published var community: MessageGroupModel
    init(interactor: MessageGroupMembersInteractor, community: MessageGroupModel) {
        self.interactor = interactor
        self.community = community
    }
}
