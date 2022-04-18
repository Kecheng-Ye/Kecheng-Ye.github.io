//
//  RecommendInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct RecommendInfo: Codable, ReflectedStringConvertible {
    let buy: Int32
    let hold: Int32
    let period: String
    let sell: Int32
    let strongBuy: Int32
    let strongSell: Int32
    let symbol: String
    
    static func example1() -> RecommendInfo {
        RecommendInfo(
            buy: 26,
            hold: 8,
            period: "2022-04-01",
            sell: 0,
            strongBuy: 18,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
    
    static func example2() -> RecommendInfo {
        RecommendInfo(
            buy: 26,
            hold: 8,
            period: "2022-03-01",
            sell: 0,
            strongBuy: 18,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
    
    static func example3() -> RecommendInfo {
        RecommendInfo(
            buy: 26,
            hold: 8,
            period: "2022-02-01",
            sell: 0,
            strongBuy: 17,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
    
    static func example4() -> RecommendInfo {
        RecommendInfo(
            buy: 25,
            hold: 7,
            period: "2022-01-01",
            sell: 0,
            strongBuy: 17,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
}

typealias RecommendInfos = [RecommendInfo]

func RecommendInfoList() -> RecommendInfos {
    [
        RecommendInfo.example1(),
        RecommendInfo.example2(),
        RecommendInfo.example3(),
        RecommendInfo.example4()
    ]
}
