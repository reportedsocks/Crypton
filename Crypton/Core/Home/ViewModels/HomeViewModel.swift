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


    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] coins in
                self?.allCoins.append(contentsOf: coins)
            }
            .store(in: &cancellables)
    }

}
