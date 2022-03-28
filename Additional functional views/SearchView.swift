//
//  SearchView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 26..
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var searchText = ""
    @State var searching = false
    var coinname: String = "coin1"
    @ObservedObject var presenter: SwapPresenter
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
            VStack(alignment: .leading) {
                SearchBar(searchText: $searchText, searching: $searching)
                    .frame(height:40)
                List {
                    ForEach(presenter.coins.filter({ (coin) -> Bool in
                        return coin.name.hasPrefix(searchText) || coin.symbol.hasPrefix(searchText.lowercased()) || searchText == ""
                    })) { coin in
                        ZStack{
                            Button(""){
                                if coinname == "coin1" {
                                    presenter.setCoin1(coin1: coin.id)
                                    //presenter.coin1 = coin.id
                                    presenter.setBuyorSell(boolean: "sell")
                                    //presenter.buyorsell = "sell"
                                    presenter.setBuyAmount()
                                } else {
                                    presenter.setCoin2(coin2: coin.id)
                                    //presenter.coin2 = coin.id
                                    presenter.setBuyorSell(boolean: "buy")
                                    //presenter.buyorsell = "buy"
                                    presenter.setSellAmount()
                                }
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            SearchListItem(coin: coin)
                        }
                        
                    }.listRowSeparatorTint(Color.theme.backgroundsecondary)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(PlainListStyle())
            }
        }.background(Color.theme.backgroundcolor)
    }
}
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
                .disableAutocorrection(true)
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
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
*/
