//
//  CurrentPrice.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct CurrentPrice: Codable, APILinkable, APIDebugable, ReflectedStringConvertible, NAInitable {
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
    
    init(currentPrice: Price, priceChange: Price, priceChangePercent: Price,
         high: Price, low: Price,
         open: Price, previousClose: Price,
         timestamp: TimeInterval) {
        
        self.currentPrice = currentPrice
        self.priceChange = priceChange
        self.priceChangePercent = priceChangePercent
        self.high = high
        self.low = low
        self.open = open
        self.previousClose = previousClose
        self.timestamp = timestamp
    }
    
    init() {
        self.currentPrice = NAPrice
        self.priceChange = NAPrice
        self.priceChangePercent = NAPrice
        self.high = NAPrice
        self.low = NAPrice
        self.open = NAPrice
        self.previousClose = NAPrice
        self.timestamp = NATime
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
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "price/\(stockTicker)")
    }
    
    func APIExample() -> CurrentPrice {
        return Self.example1()
    }
}
