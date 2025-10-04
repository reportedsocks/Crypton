//
//  NetworkingManager.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 22/9/25.
//

import Foundation
import Combine

class NetworkingManager {

    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown

        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "Bad URL response: \(url)"
            case .unknown:
                return "Unknown error occured"
            }
        }
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .retry(3)
            .eraseToAnyPublisher()
    }

    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkingError.badURLResponse(url: url)
        }

        if !(200...299).contains(response.statusCode) {
            print("❌ Bad response from \(url)")
            print("Status code:", response.statusCode)

            if let text = String(data: output.data, encoding: .utf8) {
                print("Response body:", text)
            }

            throw NetworkingError.badURLResponse(url: url)
        }

        return output.data
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            print(error.localizedDescription)
        case .finished:
            break
        }
    }

}
