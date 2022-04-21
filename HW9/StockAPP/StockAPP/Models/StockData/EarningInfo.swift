//
//  EarningInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct EarningInfo: Codable, ReflectedStringConvertible {
    let actual: Float32
    let estimate: Float32
    let period: String
    let surprise: Float32
    let surprisePercent: Float32
    let symbol: String
    
    static func example1() -> EarningInfo {
        EarningInfo(
            actual: 2.1,
            estimate: 1.9268,
            period: "2022-03-31",
            surprise: 0.1732,
            surprisePercent: 8.989,
            symbol: "AAPL"
        )
    }
    
    static func example2() -> EarningInfo {
        EarningInfo(
            actual: 1.24,
            estimate: 1.261,
            period: "2021-12-31",
            surprise: -0.021,
            surprisePercent: -1.6653,
            symbol: "AAPL"
        )
    }
    
    static func example3() -> EarningInfo {
        EarningInfo(
            actual: 1.3,
            estimate: 1.0269,
            period: "2021-09-30",
            surprise: 0.2731,
            surprisePercent: 26.5946,
            symbol: "AAPL"
        )
    }
    
    static func example4() -> EarningInfo {
        EarningInfo(
            actual: 1.4,
            estimate: 1.0064,
            period: "2021-06-30",
            surprise: 0.3936,
            surprisePercent: 39.1097,
            symbol: "AAPL"
        )
    }
}

typealias EarningInfos = [EarningInfo]

func EarningInfoList() -> [EarningInfo] {
    [
        EarningInfo.example1(),
        EarningInfo.example2(),
        EarningInfo.example3(),
        EarningInfo.example4()
    ]
}

typealias EarningInfoPlotData = (categories: [String], actual: [Float32], estimate: [Float32])

func EarningInfoListToHighChartDraw(_ infos: EarningInfos) -> EarningInfoPlotData {
    var categories: [String] = []
    var actual: [Float32] = []
    var estimate: [Float32] = []
    
    for info in infos {
        categories.append("<small>\(info.period)</small><br>Surprise: \(roundToTwoDecimal(info.surprise))")
        estimate.append(Float(roundToTwoDecimal(info.estimate))!);
        actual.append(Float(roundToTwoDecimal(info.actual))!);
    }
    
    return (categories, actual, estimate)
}
