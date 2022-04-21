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

typealias RecommendInfoPlotData = (categories: [String], strongBuy: [Int32], buy: [Int32], hold: [Int32], sell: [Int32], strongSell: [Int32])

func RecommendInfotoHighChartDraw(_ data: RecommendInfos) -> RecommendInfoPlotData {
    var categories: [String] = [];
    var strongBuy: [Int32] = [];
    var buy: [Int32] = [];
    var hold: [Int32] = [];
    var sell: [Int32] = [];
    var strongSell: [Int32] = [];
    
    for info in data {
        strongBuy.append(info.strongBuy)
        buy.append(info.buy)
        hold.append(info.hold)
        sell.append(info.sell)
        strongSell.append(info.strongSell)
        let index = info.period.index(info.period.endIndex, offsetBy: -3)
        categories.append(String(info.period[..<index]))
    }
    
    return (categories, strongBuy, buy, hold, sell, strongSell)
}
