import Combine
import Foundation

class NewsService {
    @Published var news = News(status: nil, totalResults: nil, articles: nil)
    @Published var stockNews = News(status: nil, totalResults: nil, articles: nil)

    var newssub: AnyCancellable?
    var stockNewssub: AnyCancellable?

    init() {
        loadnews()
        loadStocknews()
    }
    func loadnews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let stringdate = dateFormatter.string(from: Date())
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=crypto&from=" + stringdate + "&sortBy=publishedAt&apiKey=2755ba3f91f94ff890427a7629def7f6")
        else {
            return
        }
        let stringdateLastWeek = dateFormatter.string(from: Date.now.addingTimeInterval(-604800))
        print(stringdateLastWeek)
        newssub = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: News.self, decoder: JSONDecoder())
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] returnednews in
                self?.news = returnednews
                self?.newssub?.cancel()
            }
    }

    func loadStocknews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let stringdate = dateFormatter.string(from: Date())
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=stocks&from=" + stringdate + "&sortBy=publishedAt&apiKey=2755ba3f91f94ff890427a7629def7f6")
        else {
            return
        }
        let stringdateLastWeek = dateFormatter.string(from: Date.now.addingTimeInterval(-604800))
        print(stringdateLastWeek)
        stockNewssub = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: News.self, decoder: JSONDecoder())
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] returnednews in
                self?.stockNews = returnednews
                self?.stockNewssub?.cancel()
            }
    }
}
