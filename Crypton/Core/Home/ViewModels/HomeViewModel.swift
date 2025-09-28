//
//  HomeViewModel.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 21/9/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    @Published var statistics: [StatisticModel] = []

    @Published var allCoins: [CoinModel] = []
    @Published var portflolioCoins: [CoinModel] = []

    @Published var searchText: String = ""


    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .map(mapStats)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)

        portfolioDataService.$savedEntities
            .combineLatest($allCoins)
            .map(mapPortfolioCoins)
            .sink { [weak self] coins in
                self?.portflolioCoins = coins
            }
            .store(in: &cancellables)
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }

        let lowercasedText = text.lowercased()

        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
        }
    }

    private func mapStats(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []

        guard let marketData = marketDataModel else { return stats }

        let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: marketData.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
        let portfolioValue = StatisticModel(title: "Portfolio Value", value: "123.456", percentageChange: -25.34)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolioValue])

        return stats
    }

    private func mapPortfolioCoins(portfolio: [PortfolioEntity], coins: [CoinModel]) -> [CoinModel] {
        return coins.compactMap { coin -> CoinModel? in
            guard let entity = portfolio.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

}
