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
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)

                overviewTitle

                Divider()

                overviewGrid

                additionalTitle

                Divider()

                additionalGrid

            }
        }
        .navigationTitle(vm.coin.name)
        .padding()

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
}
