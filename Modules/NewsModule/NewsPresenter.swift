import Combine
import Foundation
import SwiftUI

class NewsPresenter: ObservableObject {
    @Published var news = News(status: nil, totalResults: nil, articles: nil)
    private let interactor: NewsInteractor
    private var cancellables = Set<AnyCancellable>()
    private let router = NewsRouter()
    private let newsTypes: NewsTypes

    init(interactor: NewsInteractor, newsType: NewsTypes) {
        self.interactor = interactor
        self.newsTypes = newsType
        if newsType == .crypto {
            interactor.getCryptoNews()
                .assign(to: \.news, on: self)
                .store(in: &cancellables)
        } else {
            interactor.getStockNews()
                .assign(to: \.news, on: self)
                .store(in: &cancellables)
        }
    }
    func linkBuilder<Content: View>(
        for article: Article,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeNewsDetailView(article: article)) {
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
}
