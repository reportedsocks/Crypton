//
//  DetailView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 28/9/25.
//

import SwiftUI

struct DetailLoadingView: View {

    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {

    @StateObject var vm: DetailViewModel
    @State private var showFullDescription: Bool = false

    private let colums: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)

                VStack(spacing: 20) {

                    overviewTitle

                    Divider()

                    descriptionSection

                    overviewGrid

                    additionalTitle

                    Divider()

                    additionalGrid

                    websiteSection

                }
                .padding()
            }

        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(vm.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        })


    }
}

#Preview {
    NavigationView {
        DetailView(coin: dev.coin)
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var overviewGrid: some View {
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStats) { stat in
                    StatisticView(stat: stat)
                }
            }
    }

    private var additionalGrid: some View {
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStats) { stat in
                    StatisticView(stat: stat)
                }
            }
    }

    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }

    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(.blue)

                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
    }

    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let website = vm.websiteUrl, let url = URL(string: website) {
                Link("Website", destination: url)
            }

            if let reddit = vm.redditUrl, let url = URL(string: reddit) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
