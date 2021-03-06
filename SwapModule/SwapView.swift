//
//  SwapView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

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
        ZStack{
            Color.theme.backgroundcolor
            
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Text("From")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(coin: "coin1")
                            .accessibilityIdentifier("SwapSellSelectorButton")
                        HStack{
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
                        
                        VStack{
                            Text("Owned:")
                            Text("\(presenter.ownedamount(coin: presenter.coin1)) \(presenter.selected(coin: presenter.coin1).symbol) ")
                        }.font(.system(size: 12))
                        
                        TextField("Amount to sell", value: .init(
                            get: { self.presenter.coinstosell },
                            set: { self.presenter.setCoinstosell(amount:Double($0)) }
                        ), formatter: formatter, onEditingChanged: { (changed) in
                            //presenter.self.coinstosell = self.coinstosell
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
                    VStack{
                        Text("To")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(coin: "coin2")
                            .accessibilityIdentifier("SwapBuySelectorButton")
                        HStack{
                            CachedAsyncImage(url: URL(string: presenter.selected(coin: presenter.coin2).image)){ image in
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
                        VStack{
                            Text("Owned:")
                            Text("\(presenter.ownedamount(coin: presenter.coin2)) \(presenter.selected(coin: presenter.coin2).symbol) ")
                        }.font(.system(size: 12))
                        
                        TextField("Amount to buy", value:.init(
                            get: { self.presenter.coinstobuy },
                            set: { self.presenter.setCoinstobuy(amount:Double($0)) }
                        )
                                    /*$presenter.returnmodel().coinstobuy*/, formatter:formatter, onEditingChanged: { (changed) in
                            if changed {
                                presenter.setBuyorSell(boolean: "buy")
                                //presenter.buyorsell = "buy"
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
                HStack(alignment:.center){
                    presenter.makeButtonForSwap()
                        .accessibilityIdentifier("SwapButton")
                    /*
                    .alert(isPresented:$showingAlert) {
                                Alert(
                                    title: Text("Are you sure you want to make a trade?"),
                                    message: Text("\(self.presenter.coinstosell.format2digits()) \(self.presenter.coin1) For \(self.presenter.coinstobuy.format2digits()) \(self.presenter.coin2)"),
                                    primaryButton: .destructive(Text("Confirm")) {
                                        print("Swapping")
                                    },
                                    secondaryButton: .cancel()
                                )
                            }*/
                }
            }
            
        }
        .background(Color.theme.backgroundcolor)
        
    }
        /*
        NavigationView {
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText, searching: $searching)
                        List {
                            ForEach(presenter.coins.filter({ (coin) -> Bool in
                                return coin.name.hasPrefix(searchText) || coin.id.hasPrefix(searchText) || searchText == ""
                            })) { coin in
                                Text(coin.name)
                            }
                        }
                            .listStyle(GroupedListStyle())
                            .navigationTitle("Select a coin")
                            .toolbar {
                                if searching {
                                    Button("Cancel") {
                                        searchText = ""
                                        withAnimation {
                                           searching = false
                                           UIApplication.shared.dismissKeyboard()
                                        }
                                    }
                                }
                            }
                            .gesture(DragGesture()
                                        .onChanged({ _ in
                                UIApplication.shared.dismissKeyboard()
                                        })
                            )
                    }
                }
    }*/
        /* VStack{
            HStack{
                VStack{
                    Text("Coin to sell")
                }
                VStack{
                    Text("Coin to buy")
                    Text("Selector")
                }
            }
        ZStack{
            Color.theme.backgroundcolor
            HStack{
                VStack{
                    Text("Egyik coin")
                    presenter.makeButtonForSelector()
                    
                }
                VStack{
                    Text("Másik coin")
                    
                    
                }
            }
            
        }
           
            Picker("Flavor", selection: $coin) {
                ForEach(presenter.coins) { coin in
                    Text(coin.name)
                }
            } */
}
/*
struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var searching: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("LightGray"))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search ..", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
    }
}


extension UIApplication {
     func dismissKeyboard() {
         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
 }

/*
struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator

        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
}
*/
 */
struct SwapView_Previews: PreviewProvider {
    static var previews: some View {
        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: DataModel())))
    }
}
