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

    let coin: CoinModel

    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: dev.coin)
}
