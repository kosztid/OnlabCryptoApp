import SwiftUI

struct StockSwapView: View {
    @ObservedObject var presenter: StockSwapPresenter
    @State private var showingAlert = false
    @FocusState private var keyboardIsFocused: Bool
    @State private var isFocused1 = false
    @State private var isFocused2 = false

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack {
                HStack {
                    Spacer()
                    sellStack
                    Spacer()
                    Image.arrowRight
                        .font(.system(size: 26))
                    Spacer()
                    buyStack
                    Spacer()
                }
                .padding(10)
                HStack(alignment: .center) {
                    presenter.makeButtonForSwap()
                        .accessibilityIdentifier("StockSwapButton")
                }
            }
            .focused($keyboardIsFocused)
        }
        .onDisappear {
            keyboardIsFocused = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(Strings.done) {
                    keyboardIsFocused = false
                }
            }
        }
        .onAppear(perform: presenter.loadService)
        .background(Color.theme.backgroundcolor)
    }

    var sellStack: some View {
        VStack {
            Text(Strings.from)
                .font(.system(size: 26))
                .bold()
            presenter.makeButtonForSelector(bos: .toSell)
                .accessibilityIdentifier("StockSwapSellSelectorButton")
            Text(presenter.stockmodel1.symbol)
                .font(.system(size: 20))
            VStack {
                Text(Strings.owned)
                Text("\(presenter.ownedamount(stockSymbol: presenter.stockmodel1.symbol)) \(presenter.stockmodel1.symbol) ")
            }.font(.system(size: 12))

            sellTextfield
        }
        .font(.system(size: 24))
        .foregroundColor(Color.theme.accentcolor)
    }

    var buyStack: some View {
        VStack {
            Text(Strings.to)
                .font(.system(size: 26))
                .bold()
            presenter.makeButtonForSelector(bos: .toBuy)
                .accessibilityIdentifier("StockSwapBuySelectorButton")
            Text(presenter.stockmodel2.symbol)
                .font(.system(size: 20))
            VStack {
                Text(Strings.owned)
                Text("\(presenter.ownedamount(stockSymbol: presenter.stockmodel2.symbol)) \(presenter.stockmodel2.symbol) ")
            }.font(.system(size: 12))

            buyTextfield
        }
        .font(.system(size: 24))
        .foregroundColor(Color.theme.accentcolor)
    }
    var sellTextfield: some View {
        // swiftlint:disable:next trailing_closure
        TextField(Strings.sellAmount, value: $presenter.stockstosell, formatter: formatter, onEditingChanged: { changed in
            isFocused2 = changed
        })
        .onChange(of: presenter.stockstosell) { _ in
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
        .accessibilityIdentifier("StockSwapSellTextField")
    }

    var buyTextfield: some View {
        // swiftlint:disable:next trailing_closure
        TextField(Strings.buyAmount, value: $presenter.stockstobuy, formatter: formatter, onEditingChanged: { changed in
            isFocused1 = changed
        })
        .onChange(of: presenter.stockstobuy) { _ in
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
        .accessibilityIdentifier("StockSwapBuyTextField")
    }
}
