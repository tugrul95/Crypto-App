//
//  InfoViewModel.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation
import Combine

class InfoViewModel: ObservableObject {
    
    @Published var overviewStatistics: [Statistics] = []
    @Published var additionalStatistics: [Statistics] = []
    @Published var coin: Coin
    @Published var coinDescription: String?
    @Published var coinWebsite: String?
    @Published var coinSubreddit: String?
    
    private let coinInfoDataService: CoinInfoDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinInfoDataService = CoinInfoDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinInfoDataService.$coinInfo
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { returnCoinDetails in
                self.overviewStatistics = returnCoinDetails.overview
                self.additionalStatistics = returnCoinDetails.additional
            }
            .store(in: &cancellables)
        
        coinInfoDataService.$coinInfo
            .sink { [weak self] returnCoinDetails in
                self?.coinDescription = returnCoinDetails?.readableDescription
                self?.coinWebsite = returnCoinDetails?.links?.homepage?.first
                self?.coinSubreddit = returnCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinInfo?, coinModel: Coin) -> (overview: [Statistics], additional: [Statistics]) {
        let overview = createOverview(coinModel: coinModel)
        let additional = createAdditional(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overview, additional)
    }
    
    private func createOverview(coinModel: Coin) -> [Statistics] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = Statistics(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = Statistics(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = Statistics(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistics(title: "Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    private func createAdditional(coinDetailModel: CoinInfo?, coinModel: Coin) -> [Statistics] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistics(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistics(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = Statistics(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChangePercentage24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = Statistics(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistics(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistics(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
    }
    
}
