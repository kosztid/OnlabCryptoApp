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
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text(article.title ?? "Nincs cím")
                            .font(.system(size: 26))
                            .frame(alignment: .leading)
                            .foregroundColor(Color.theme.accentcolor)
                    }.frame(alignment: .leading)
                    HStack {
                        HStack {
                            Text(article.author ?? "Nincs szerző")
                                .font(.system(size: 16))
                                .frame(alignment: .leading)
                                .foregroundColor(Color.theme.accentcolorsecondary)
                        }
                        Spacer()
                        HStack {
                            Text(article.publishedAt ?? "PublishDate")
                                .font(.system(size: 16))
                                .frame(alignment: .leading)
                                .foregroundColor(Color.theme.accentcolorsecondary)
                        }
                    }
                    .padding(.horizontal, 5.0)
                    CachedAsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .frame(width: UIScreen.main.bounds.width*0.95)
                    }
                    .frame(width: UIScreen.main.bounds.width*0.95)
                    .cornerRadius(20)
                }
                .padding(.bottom, 10)
                VStack {
                    Text(article.content?.dropLast(13) ?? "Nincs szöveg")
                        .font(.body)
                        .foregroundColor(Color.theme.accentcolor)
                        .multilineTextAlignment(.leading)

                    Link("Continue reading", destination: URL(string: article.url!)!)
                        .foregroundColor(Color.theme.accentcolorsecondary)
                }
            }
            .padding(10)
        }   
    }
}
