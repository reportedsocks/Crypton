//
//  MarketDataService.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 23/9/25.
//

import Foundation
import Combine

class MarketDataService {

    @Published var marketData: MarketDataModel? = nil
    var dataSubscription: AnyCancellable?

    init() {
        getMarketData()
    }

    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

        dataSubscription = NetworkingManager
            .download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion(completion:),
                receiveValue: { [weak self] globalData in
                    self?.marketData = globalData.data
                    self?.dataSubscription?.cancel()
                }
            )

    }

}
