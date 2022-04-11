//
//  CurrentPrice.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct CurrentPrice: Codable {
    let currentPrice: Price
    let priceChange: Price
    let priceChangePercent: Price
    let high: Price
    let low: Price
    let open: Price
    let previousClose: Price
    let timestamp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case priceChange = "d"
        case priceChangePercent = "dp"
        case high = "h"
        case low = "l"
        case open = "o"
        case previousClose = "pc"
        case timestamp = "t"
    }
    
    static func example1() -> CurrentPrice {
        CurrentPrice(
            currentPrice: 151.17,
            priceChange: -3.56,
            priceChangePercent: -2.3008,
            high: 154.12,
            low: 150.45,
            open: 151.45,
            previousClose: 154.73,
            timestamp: 1641647281134
        )
    }
    
    static func example2() -> CurrentPrice {
        CurrentPrice(
            currentPrice: 151.17,
            priceChange: 3.56,
            priceChangePercent: 2.3008,
            high: 154.12,
            low: 150.45,
            open: 151.45,
            previousClose: 154.73,
            timestamp: 1641647281134
        )
    }
    
    static func example3() -> CurrentPrice {
        CurrentPrice(
            currentPrice: 151.17,
            priceChange: 0,
            priceChangePercent: 0,
            high: 154.12,
            low: 150.45,
            open: 151.45,
            previousClose: 154.73,
            timestamp: 1641647281134
        )
    }
}
