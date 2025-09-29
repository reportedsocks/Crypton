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
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
        
        portfolioDataService.$savedEntities
            .combineLatest($allCoins)
            .map(mapPortfolioCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portflolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portflolioCoins)
            .map(mapStats)
            .sink { [weak self] stats in
                self?.statistics = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(text: text, coins: coins)

        sortCoins(sortOption: sortOption, coins: &filteredCoins)

        return filteredCoins
    }
    
    private func sortCoins(sortOption: SortOption, coins: inout [CoinModel]) {
        switch sortOption {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
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

    private func mapStats(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []

        guard let marketData = marketDataModel else { return stats }

        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0.0, +)

        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0.0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: marketData.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
        let portfolioStat = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolioStat])

        return stats
    }

    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // only by holdings
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default :
            return coins
        }

    }

    private func mapPortfolioCoins(portfolio: [PortfolioEntity], coins: [CoinModel]) -> [CoinModel] {
        return coins.compactMap { coin -> CoinModel? in
            guard let entity = portfolio.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

}
