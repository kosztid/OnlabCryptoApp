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
    @Published var communities: [MessageGroupModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let interactor: CommunitiesInteractor
    @Published var signedin : Bool = false
    private let router = CommunitiesRouter()
    
    init(interactor: CommunitiesInteractor){
        self.interactor = interactor
        interactor.model.$communities
            .assign(to: \.communities, on:self)
            .store(in: &cancellables)
        
        interactor.model.$isSignedIn
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)
    }
    
    func linkBuilder<Content: View>(
        for community: MessageGroupModel,
        @ViewBuilder content: () -> Content
    ) -> some View{
        NavigationLink(destination:router.gotoChat(model: interactor.model,  community:community)){
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
    func addCommunity(_ name: String) {
        interactor.model.addCommunity(name: name)
    }
    func makeButtonForAdd() -> some View {
        NavigationLink("Add Community", destination: router.makeCommunityAdderView(model: interactor.model))
    }
    func makeButtonForLogin() -> some View {
        NavigationLink("Account", destination: router.makeLoginView(model: interactor.model))
    }
    
    func makeButtonForAccount() -> some View {
        NavigationLink("Account", destination: router.makeAccountView(model: interactor.model))
    }
}
