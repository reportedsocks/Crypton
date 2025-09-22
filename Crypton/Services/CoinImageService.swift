//
//  CoinImageService.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 22/9/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {

    @Published var image: UIImage? = nil

    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }

        imageSubscription = NetworkingManager
            .download(url: url)
            .tryMap { UIImage(data: $0) }
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion(completion:),
                receiveValue: { [weak self] returnedImage in
                    guard let self, let downloadedImage = returnedImage else { return }
                    self.image = returnedImage
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
                }
            )
    }
}
