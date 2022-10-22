import SwiftUI

struct SwapView: View {
    @ObservedObject var presenter: SwapPresenter
    @State private var showingAlert = false
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    @State private var isFocused1 = false
    @State private var isFocused2 = false

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("From")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(coin: "coin1")
                            .accessibilityIdentifier("SwapSellSelectorButton")
                        sellCoinData
                        VStack {
                            Text("Owned:")
                            Text("\(presenter.ownedamount(coinid: presenter.coinmodel1.id)) \(presenter.coinmodel1.symbol) ")
                        }
                        .font(.system(size: 12))
                        sellTextfield
                    }
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.accentcolor)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 26))
                    Spacer()
                    VStack {
                        Text("To")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(coin: "coin2")
                            .accessibilityIdentifier("SwapBuySelectorButton")
                        buyCoinData
                        VStack {
                            Text("Owned:")
                            Text("\(presenter.ownedamount(coinid: presenter.coinmodel2.id)) \(presenter.coinmodel2.symbol)")
                        }
                        .font(.system(size: 12))
                        buyTextfield
                    }
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.accentcolor)
                    Spacer()
                }
                .padding(10)
                HStack(alignment: .center) {
                    presenter.makeButtonForSwap()
                        .accessibilityIdentifier("SwapButton")
                }
            }
        }
        .onAppear(perform: presenter.loadService)
        .background(Color.theme.backgroundcolor)
    }

    var testField: some View {
        TextField("Amount to buy", value: .init(
            get: { self.presenter.coinstobuy },
            set: { self.presenter.setCoinstobuy(amount: Double($0)) }
        ), formatter: formatter, onEditingChanged: { changed in
            if changed {
                presenter.setBuyorSell(boolean: "buy")
            } else {
                presenter.setSellAmount()
            }
        })
    }

    var buyTextfield: some View {
        TextField("Amount to buy", value: $presenter.coinstobuy, formatter: formatter, onEditingChanged: { changed in
            isFocused1 = changed
        })
        .onChange(of: presenter.coinstobuy) { _ in
            if isFocused1 {
                presenter.setSellAmount()
            }
        }
        .padding(.horizontal)
        .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .font(.system(size: 20))
        .foregroundColor(Color.theme.accentcolor)
        .background(Color.theme.backgroundcolor)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
        .cornerRadius(10)
        .disableAutocorrection(true)
        .keyboardType(.numberPad)
        .accessibilityIdentifier("SwapBuyTextField")
    }

    var sellTextfield: some View {
        TextField("Amount to sell", value: $presenter.coinstosell, formatter: formatter, onEditingChanged: { changed in
            isFocused2 = changed
        })
        .onChange(of: presenter.coinstosell) { _ in
            if isFocused2 {
                presenter.setBuyAmount()
            }
        }
            .padding(.horizontal)
            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.system(size: 20))
            .foregroundColor(Color.theme.accentcolor)
            .background(Color.theme.backgroundcolor)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
            .cornerRadius(10)
            .disableAutocorrection(true)
            .keyboardType(.numberPad)
            .accessibilityIdentifier("SwapSellTextField")
    }

    var sellCoinData: some View {
        HStack {
            CachedAsyncImage(url: URL(string: presenter.coinmodel1.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Circle()
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 30)
            .cornerRadius(20)
            Text(presenter.coinmodel1.name)
                .font(.system(size: 20))
        }
    }

    var buyCoinData: some View {
        HStack {
            CachedAsyncImage(url: URL(string: presenter.coinmodel2.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Circle()
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 30)
            .cornerRadius(20)
            Text(presenter.coinmodel2.name)
                .font(.system(size: 20))
        }
    }
}

struct SwapView_Previews: PreviewProvider {
    static var previews: some View {
        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: DataModel())))
    }
}