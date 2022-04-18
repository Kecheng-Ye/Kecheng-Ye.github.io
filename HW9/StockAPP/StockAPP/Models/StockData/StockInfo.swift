//
//  StockInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import Foundation

struct StockInfo: ReflectedStringConvertible {
    var companyBrief = CompanyBrief()
    var currentPrice = CurrentPrice()
    var hourlyPrice  = HourlyPrice()
    var peers = Peers()
    var news = News()
    var historicRecord = HistoricalRecord()
    var recommendInfos = RecommendInfos()
    var earningInfos = EarningInfos()
    var socialSentiments = SocialSentimentList()
    
    mutating func updateProperty(name: String, value: AnyObject) {
        switch name {
        case "companyBrief": self.companyBrief = value as! CompanyBrief
        case "currentPrice": self.currentPrice = value as! CurrentPrice
        case "hourlyPrice": self.hourlyPrice = value as! HourlyPrice
        case "peers": self.peers = value as! Peers
        case "news": self.news = value as! News
        case "historicRecord": self.historicRecord = value as! HistoricalRecord
        case "recommendInfos": self.recommendInfos = value as! RecommendInfos
        case "earningInfos": self.earningInfos = value as! EarningInfos
        case "socialSentiments": self.socialSentiments = value as! SocialSentimentList
        default: fatalError("Wrong Key")
        }
    }
}


