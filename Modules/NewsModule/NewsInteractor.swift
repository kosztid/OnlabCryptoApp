import Foundation

class NewsInteractor {
    let newsService: NewsService

    init() {
        newsService = NewsService()
    }

    func getCryptoNews() -> Published<News>.Publisher {
        newsService.$news
    }
    func getStockNews() -> Published<News>.Publisher {
        newsService.$stockNews
    }
}
