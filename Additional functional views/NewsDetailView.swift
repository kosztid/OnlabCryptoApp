//
//  NewsDetailView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 18..
//

import SwiftUI

struct NewsDetailView: View {
    var article: Article
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    CachedAsyncImage(url: URL(string: article.urlToImage ?? "")){ image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .frame(width: UIScreen.main.bounds.width*0.95)
                    }
                    .frame(width: UIScreen.main.bounds.width*0.95)
                    .cornerRadius(20)
                    HStack{
                        Text(article.title ?? "Nincs cím")
                            .font(.system(size: 20))
                            .frame(alignment: .leading)
                            .foregroundColor(Color.theme.accentcolor)
                    }.frame(alignment: .leading)
                    HStack{
                        Text(article.author ?? "Nincs szerző")
                            .font(.system(size: 16))
                            .frame(alignment: .leading)
                            .foregroundColor(Color.theme.accentcolorsecondary)
                    }.frame(alignment: .leading)
                }
                .padding(.bottom,10)
                .frame(alignment: .leading)
                HStack{
                    Text(article.content ?? "Nincs szöveg")
                        .font(.system(size: 16))
                        .foregroundColor(Color.theme.accentcolor)
                }
            }
            .padding(10)
        }
            
    }
}
/*
struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView()
    }
}
*/
