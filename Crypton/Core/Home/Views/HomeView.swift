//
//  HomeView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 20/9/25.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var vm: HomeViewModel

    @State private var showPortfolio: Bool = false
    @State private var chevronRotation: Angle = .zero
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false

    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailedView: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(edges: .all)
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }

            VStack {
                homeHeader

                HomeStatsView(showPortfolio: $showPortfolio)

                SearchBarView(searchText: $vm.searchText)

                columTitles

                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }

                if showPortfolio {
                    portflioCoinsList
                        .transition(.move(edge: .trailing))
                }


                Spacer()
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailedView,
                label: { EmptyView()}
            )
        )
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(dev.homeViewModel)
}

extension HomeView {

    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }

            Spacer()

            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortfolio)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .onTapGesture {
                    withAnimation {
                        showPortfolio.toggle()
                    }

                }
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .animation(.spring, value: showPortfolio)
        }
        .padding(.horizontal)
    }

    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }

            }
        }
        .listStyle(.plain)
        .refreshable {
            withAnimation(.linear(duration: 2)) {
                vm.reloadData()
                HapticManager.notification(type: .success)
            }

        }
    }

    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailedView.toggle()
    }

    private var portflioCoinsList: some View {
        List {
            ForEach(vm.portflolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
    }

    private var columTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(vm.sortOption == .rank ? Angle(degrees: 0) : Angle(degrees: 180))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }

            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(vm.sortOption == .holdings ? Angle(degrees: 0) : Angle(degrees: 180))
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")

                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(vm.sortOption == .price ? Angle(degrees: 0) : Angle(degrees: 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }

            Button {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                    HapticManager.notification(type: .success)
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            }


        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
