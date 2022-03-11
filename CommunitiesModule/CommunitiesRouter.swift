//
//  CommunitiesRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 11..
//

import Foundation
import SwiftUI

class CommunitiesRouter{
    func gotoChat(model: DataModel,community: MessageGroup) -> some View{
        let presenter = MessagerPresenter(interactor: MessagerInteractor(model: model),community: community)
        return MessagerView(presenter: presenter)
    }
}
