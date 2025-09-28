//
//  PortfolioView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 27/9/25.
//

import SwiftUI

struct PortfolioView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)

                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(action: { dismiss() })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarItems
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(dev.homeViewModel)
}

extension PortfolioView {

    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portflolioCoins : vm.allCoins) { coin in
                    CoinLogoItem(
                        coin: coin,
                        isSelected: selectedCoin?.id == coin.id
                    )
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            updateSelectedCoin(coin: coin)
                        }
                    }
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }

    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portflolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }

    }

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }

            Divider()

            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            Divider()

            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .animation(.none, value: selectedCoin)
    }

    private var trailingNavBarItems: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0)
            Button("SAVE") {
                saveButtonPresssed()
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1 : 0)
        }
        .font(.headline)
    }

    private func getCurrentValue() -> Double {
        if let quanity = Double(quantityText) {
            return quanity * (selectedCoin?.currentPrice ?? 0)
        } else {
            return 0.0
        }
    }

    private func saveButtonPresssed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }

        vm.updatePortfolio(coin: coin, amount: amount)

        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }

        UIApplication.shared.endEditing()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeIn) {
                showCheckMark = false
            }
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}

struct CoinLogoItem: View {
    let coin: CoinModel
    let isSelected: Bool

    var body: some View {
        CoinLogoView(coin: coin)
            .frame(width: 75)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.theme.green : Color.clear,
                            lineWidth: 1)
            )
    }
}
