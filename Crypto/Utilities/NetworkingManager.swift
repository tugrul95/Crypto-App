//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation
import Combine

/// Functions for easily managing data from a URL
class NetworkingManager {
    
    /// Custom Errors for NetworkingManager
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "[⛔️] Bad response from URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLReponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }
    
    static func handleURLReponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
