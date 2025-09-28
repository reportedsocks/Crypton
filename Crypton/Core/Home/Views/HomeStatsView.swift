//
//  HomeStatsView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 23/9/25.
//

import SwiftUI

struct HomeStatsView: View {

    @Binding var showPortfolio: Bool

    @EnvironmentObject private var vm: HomeViewModel

    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(true))
        .environmentObject(dev.homeViewModel)
}
