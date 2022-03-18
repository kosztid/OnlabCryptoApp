//
//  NewsListItem.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 18..
//

import SwiftUI

struct NewsListItem: View {
    @ObservedObject var presenter: NewsPresenter
    var article: Article
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            
            HStack{
                Text(article.title!)
                    .foregroundColor(Color.theme.accentcolor)
            }
        }
    }
}
/*
struct NewsListItem_Previews: PreviewProvider {
    static var previews: some View {
        NewsListItem()
    }
}
*/
