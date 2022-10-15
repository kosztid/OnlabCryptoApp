import SwiftUI

struct NewsListItem: View {
    @ObservedObject var presenter: NewsPresenter
    var article: Article
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            HStack {
                Text(article.title!)
                    .font(.system(size: 16))
                    .frame(alignment: .leading)
                    .foregroundColor(Color.theme.accentcolor)
                Spacer()
            }.frame(alignment: .leading)
                .padding(5)
        }
    }
}
