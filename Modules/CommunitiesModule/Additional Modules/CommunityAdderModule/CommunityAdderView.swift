//
//  CommunityAdderView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 01..
//

import SwiftUI

struct CommunityAdderView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var presenter: CommunityAdderPresenter
    @State var communityname = ""
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Please choose a name for you community:")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 20))
                    TextField("Name...", text: $communityname)
                        .padding(.horizontal)
                        .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme.accentcolor)
                        .background(Color.theme.backgroundcolor)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .accessibilityIdentifier("CommunityadderTextField")
                }
                Button {
                    if communityname.isEmpty {
                        presenter.addCommunity(name: communityname)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Add")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme.accentcolor)
                        .background(Color.theme.backgroundsecondary)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("CommunityadderButton")
            }
        }
        .padding(10)
        .background(Color.theme.backgroundcolor)
    }
}
