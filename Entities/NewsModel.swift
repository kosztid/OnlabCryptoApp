import Foundation

struct News: Codable, Hashable {
    let status: String?
    let totalResults: Double?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable, Hashable {
    let source: Source?
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    var content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable, Hashable {
    let id: String?
    let name: String?
}
