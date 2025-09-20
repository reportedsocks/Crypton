//
//  CoinModel.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 20/9/25.
//

import Foundation

/*
 curl --request GET \
   --url 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&per_page=250&sparkline=true' \
   --header 'x-cg-demo-api-key: <key>'

 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
 "current_price": 115975,
 "market_cap": 2311369646230,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 2311369646230,
 "total_volume": 21789837151,
 "high_24h": 116154,
 "low_24h": 115157,
 "price_change_24h": -61.289563721220475,
 "price_change_percentage_24h": -0.05282,
 "market_cap_change_24h": -45039339.05078125,
 "market_cap_change_percentage_24h": -0.00195,
 "circulating_supply": 19923296,
 "total_supply": 19923296,
 "max_supply": 21000000,
 "ath": 124128,
 "ath_change_percentage": -6.52949,
 "ath_date": "2025-08-14T00:37:02.582Z",
 "atl": 67.81,
 "atl_change_percentage": 171002.82329,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2025-09-20T16:19:51.465Z",
 "sparkline_in_7d": {
 "price": [
 116020.66710769299,
 115804.7284527069,
 115720.80222969536,
 115784.63989667728
 ]
 },
 "price_change_percentage_24h_in_currency": -0.05281927721432926
 }
 */

struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }

    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24H, currentHoldings: amount)
    }

    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }

    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
