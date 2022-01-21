//
//  MarketInfo.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation

// CoinGecko API Info
/*
 URL:
    https://api.coingecko.com/api/v3/global
 */

/// CoinGecko API global market data
struct GlobalData: Codable {
    let data: MarketInfo?
}

/// Values included in the global market data CoinGecko API call
struct MarketInfo: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    /// Gets the current global market cap in USD as a String
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    /// Gets the current global market volume in USD as a String
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    /// Gets the current global cap percentage for BTC as a String
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
    
}
