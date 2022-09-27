//
//  NewsPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 18..
//

import Foundation
import Combine
import SwiftUI

class NewsPresenter: ObservableObject{
    @Published var news: News = News(status: nil, totalResults: nil, articles: nil)
    private let interactor: NewsInteractor
    private var cancellables = Set<AnyCancellable>()
    private let router = NewsRouter()
    
    init(interactor: NewsInteractor){
        self.interactor = interactor
        interactor.model.$news
            .assign(to: \.news, on: self)
            .store(in: &cancellables)
    }
    
    func linkBuilder<Content: View>(
        for article: Article,
        @ViewBuilder content: () -> Content
    ) -> some View{
        NavigationLink(destination:router.makeNewsDetailView(article: article)){
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
}
