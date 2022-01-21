//
//  Statistics.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation

/// Statistics model used for StatisticsView
struct Statistics: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
