//
//  CoinInfoDataService.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation
import Combine

class CoinInfoDataService {
    
    @Published var coinInfo: CoinInfo?
    
    var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            print("Invalid URL")
            return
        }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinInfo.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] returnCoinInfo in
                self?.coinInfo = returnCoinInfo
                self?.coinDetailSubscription?.cancel()
            })
    }
}
