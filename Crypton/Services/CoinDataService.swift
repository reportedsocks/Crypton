//
//  CoinDataService.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 21/9/25.
//

import Foundation
import Combine

class CoinDataService {

    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&per_page=250&sparkline=true") else { return }

        coinSubscription = NetworkingManager
            .download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion(completion:),
                receiveValue: { [weak self] returnedCoins in
                    self?.allCoins = returnedCoins
                    self?.coinSubscription?.cancel()
                }
            )
    }

}
