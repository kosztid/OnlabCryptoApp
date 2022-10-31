import Foundation
import SwiftUI

class NewsRouter {
    func makeNewsDetailView(article: Article) -> some View {
        NewsDetailView(article: article)
    }
}
