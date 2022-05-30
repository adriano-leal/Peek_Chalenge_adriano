//
//  SwiftUIView.swift
//  GithubGraphQL
//
//  Created by Adriano Leal on 30/05/22.
//  Copyright © 2022 test. All rights reserved.
//

import SwiftUI
import Apollo

struct SwiftUIView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            CellCard(name: viewModel.repos.first?.name ?? "",
                     stars: viewModel.repos.first?.stargazers.totalCount ?? 0,
                     owner: viewModel.repos.first?.owner.login ?? "",
                     imgUrl: viewModel.repos.first?.owner.avatarUrl ?? "avatar") {
                if let url = URL(string: viewModel.repos.first?.url ?? "") {
                    UIApplication.shared.open(url)
                }
            }
            Divider()
            CellCard(name: viewModel.repos.first?.name ?? "",
                     stars: viewModel.repos.first?.stargazers.totalCount ?? 0,
                     owner: viewModel.repos.first?.owner.login ?? "",
                     imgUrl: viewModel.repos.first?.url ?? "") {
                if let url = URL(string: viewModel.repos.first?.url ?? "") {
                    UIApplication.shared.open(url)
                }
            }
        }
        .padding()
    }
}

struct CellCard: View {
    
    let name: String
    let stars: Int
    let owner: String
    let imgUrl: String
    let actionHandler: (() -> Void)
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "avatar")!)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 10)
            VStack(alignment: .leading) {
                nameLabel
                ownerLabel
                starsLabel
            }
            .padding(.horizontal, 5)
            Spacer()
        }
        .padding(15)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            actionHandler()
        }
    }
    
    private var nameLabel: some View {
        Text(name)
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(2)
            .padding(.bottom, 5)
    }
    
    private var iconImage: some View {
        Image(uiImage: UIImage(named: "avatar")!)
            .resizable()
            .frame(width: 80, height: 80)
    }
    
    private var starsLabel: some View {
        Text("\(stars) ⭐️")
    }
    
    private var ownerLabel: some View {
        Text("Owned by \(owner)")
            .padding(.bottom, 5)
    }
    
    
}
