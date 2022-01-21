//
//  CoinInfo.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation

// CoinGecko API Info
/*
 URL:
    https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
 */

/// Represents additional information for a particular cryptocurrency returned from the CoinGecko API
struct CoinInfo: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
    /// Gets description with HTML links removed
    var readableDescription: String? {
        return description?.en?.removeHTMLOccurrences
    }
}

/// Important links for this coin, specifically the main website and subreddit
struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
