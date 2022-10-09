import SwiftUI


struct SwapView: View {
    @ObservedObject var presenter: SwapPresenter
    @State private var showingAlert = false
    // @State var coinstobuy : Double = 0
    // @State var coinstosell : Double = 0
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
                    VStack {
                        Text("From")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(coin: "coin1")
                            .accessibilityIdentifier("SwapSellSelectorButton")
                        HStack {
                            CachedAsyncImage(url: URL(string: presenter.selected(coin: presenter.coin1).image)){ image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Circle()
                                    .frame(width: 30, height: 30)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(20)
                            Text(presenter.selected(coin: presenter.coin1).name)
                                .font(.system(size: 20))
                        }
                        VStack {
                            Text("Owned:")
                            Text("\(presenter.ownedamount(coin: presenter.coin1)) \(presenter.selected(coin: presenter.coin1).symbol) ")
                        }.font(.system(size: 12))
                        TextField("Amount to sell", value: .init(
                            get: { self.presenter.coinstosell },
                            set: { self.presenter.setCoinstosell(amount:Double($0)) }
                        ), formatter: formatter, onEditingChanged: { (changed) in
                            // presenter.self.coinstosell = self.coinstosell
                            if changed {
                                presenter.setBuyorSell(boolean: "sell")
                            } else {
                                presenter.setBuyAmount()
                            }
                        }).padding(.horizontal)
                            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 20))
                            .foregroundColor(Color.theme.accentcolor)
                            .background(Color.theme.backgroundcolor)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
                            .cornerRadius(10)
                            .disableAutocorrection(true)
                            .accessibilityIdentifier("SwapSellTextField")
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
                        HStack {
                            CachedAsyncImage(url: URL(string: presenter.selected(coin: presenter.coin2).image)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Circle()
                                    .frame(width: 30, height: 30)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(20)
                            Text(presenter.selected(coin: presenter.coin2).name)
                                .font(.system(size: 20))
                        }
                        VStack {
                            Text("Owned:")
                            Text("\(presenter.ownedamount(coin: presenter.coin2)) \(presenter.selected(coin: presenter.coin2).symbol) ")
                        }.font(.system(size: 12))
                        
                        TextField("Amount to buy", value: .init(
                            get: { self.presenter.coinstobuy },
                            set: { self.presenter.setCoinstobuy(amount: Double($0)) }
                        ), formatter: formatter, onEditingChanged: { (changed) in
                            if changed {
                                presenter.setBuyorSell(boolean: "buy")
                            } else {
                                presenter.setSellAmount()
                            }
                        })
                            .padding(.horizontal)
                            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 20))
                            .foregroundColor(Color.theme.accentcolor)
                            .background(Color.theme.backgroundcolor)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
                            .cornerRadius(10)
                            .disableAutocorrection(true)
                            .accessibilityIdentifier("SwapBuyTextField")
                        // .onChange(of: presenter.coinstobuy){presenter.setSellAmount()}
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
        .background(Color.theme.backgroundcolor)
    }
}

struct SwapView_Previews: PreviewProvider {
    static var previews: some View {
        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: DataModel())))
    }
}
