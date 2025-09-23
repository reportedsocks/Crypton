//
//  HomeViewModel.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 21/9/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    @Published var allCoins: [CoinModel] = []
    @Published var portflolioCoins: [CoinModel] = []

    @Published var searchText: String = ""


    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
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

}
