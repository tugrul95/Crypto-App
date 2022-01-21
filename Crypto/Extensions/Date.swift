//
//  Date.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation

extension Date {
    
    /// Creates a date from a CoinGecko API String date
    /// - Parameter coinGeckoDate: String date used by CoinGecko API
    init(coinGeckoDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoDate) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    /// Converts a Date to a short date style as a String

    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
}
