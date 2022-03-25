//
//  SwapView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI



struct SwapView: View {
    @State var coin : String = ""
    @State var coin2 : String = ""
    @State private var searchTerm: String = ""
    @State private var searchTerm2: String = ""
    @State var searchText = ""
    @State var searchText2 = ""
    @ObservedObject var presenter: SwapPresenter
    var body: some View {
        /*VStack{
            HStack{
                VStack{
                    Text("Coin to sell")
                }
                VStack{
                    Text("Coin to buy")
                    Text("Selector")
                }
            }
            */
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
            
        /*
            Picker("Flavor", selection: $coin) {
                ForEach(presenter.coins) { coin in
                    Text(coin.name)
                }
            }*/
    }
}

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

struct SwapView_Previews: PreviewProvider {
    static var previews: some View {
        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: DataModel())))
    }
}
