//
//  DetailViewModel.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 29/9/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {

    private var cancellables = Set<AnyCancellable>()
    private let coinDetailService: CoinDetailDataService
    @Published var coin: CoinModel

    @Published var overviewStats: [StatisticModel] = []
    @Published var additionalStats: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteUrl: String? = nil
    @Published var redditUrl: String? = nil

    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapCoinDetails)
            .sink { [weak self] returnedCoinDetails in
                self?.overviewStats = returnedCoinDetails.overview
                self?.additionalStats = returnedCoinDetails.additional
            }
            .store(in: &cancellables)

        coinDetailService.$coinDetails
            .sink { [weak self] details in
                self?.coinDescription = details?.readableDescription
                self?.websiteUrl = details?.links?.homepage?.first
                self?.redditUrl = details?.links?.subredditURL
            }
            .store(in: &cancellables)
    }

    private func mapCoinDetails(details: CoinDetailModel?, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {

        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let priceChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: priceChange)

        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "N/A")
        let marketChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketChange)

        let rank  = "\(coin.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "N/A")
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        let overview: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]

        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStat = StatisticModel(title: "24h High", value: high)

        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStat = StatisticModel(title: "24h Low", value: low)

        let priceChange24h = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let pricePercentChange24h = coin.priceChangePercentage24H
        let priceChangeStat24h = StatisticModel(title: "24h Price Change", value: priceChange24h, percentageChange: pricePercentChange24h)

        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange24h = coin.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange24h)

        let blockTime = details?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = details?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(title: "Hashing algorithm", value: hashing)

        let additional = [highStat, lowStat, priceChangeStat24h, marketCapChangeStat, blockStat, hashingStat]

        return (overview, additional)
    }
}
