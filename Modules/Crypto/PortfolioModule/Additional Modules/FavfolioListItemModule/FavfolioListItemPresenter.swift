import Foundation
import SwiftUI

class FavfolioListItemPresenter: ObservableObject {
    private let interactor: FavfolioListItemInteractor

    init(interactor: FavfolioListItemInteractor) {
        self.interactor = interactor
    }

    func getcoin() -> CoinModel {
        interactor.getcoin()
    }

    func getFavImage() -> Image {
        interactor.isFav() ? Image.starFill : Image.star
    }
    func makeFavButton() -> some View {
        Button {
            self.interactor.addFavCoin()
        } label: {
            self.getFavImage()
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 22))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
