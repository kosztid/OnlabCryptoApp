//
//  CommunitiesPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import SwiftUI
import Combine

class CommunitiesPresenter: ObservableObject{
    @Published var communities: [MessageGroup] = []
    private var cancellables = Set<AnyCancellable>()
    private let interactor: CommunitiesInteractor
    private let router = CommunitiesRouter()
    
    init(interactor: CommunitiesInteractor){
        self.interactor = interactor
        interactor.model.$communities
            .assign(to: \.communities, on:self)
            .store(in: &cancellables)
    }
    
    func linkBuilder<Content: View>(
        for community: MessageGroup,
        @ViewBuilder content: () -> Content
    ) -> some View{
        NavigationLink(destination:router.gotoChat(model: interactor.model,  community:community)){
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
    
}
