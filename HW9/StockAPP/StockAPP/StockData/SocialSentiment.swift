//
//  SocialSentiment.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct SocialSentiment: Codable, ReflectedStringConvertible {
    let atTime: String
    let mention: Int32
    let positiveScore: Float32
    let negativeScore: Float32
    let positiveMention: Int32
    let negativeMention: Int32
    let score: Float32
    
    static func example1() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-11 02:00:00",
            mention: 4,
            positiveScore: 0.991375,
            negativeScore: 0,
            positiveMention: 4,
            negativeMention: 0,
            score: 0.991375
        )
    }
    
    static func example2() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-11 01:00:00",
            mention: 5,
            positiveScore: 0.98899975,
            negativeScore: -0.99964607,
            positiveMention: 4,
            negativeMention: 1,
            score: 0.991129014
        )
    }
    
    static func example3() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-11 00:00:00",
            mention: 1,
            positiveScore: 0,
            negativeScore: -0.8038017,
            positiveMention: 0,
            negativeMention: 1,
            score: 0.8038017
        )
    }
    
    static func example4() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-10 22:00:00",
            mention: 1,
            positiveScore: 0,
            negativeScore: -0.9982066,
            positiveMention: 0,
            negativeMention: 1,
            score: 0.9982066
        )
    }
}

struct SocialSentimentList: Codable, APILinkable, APIDebugable, ReflectedStringConvertible {
    let reddit: [SocialSentiment]
    let twitter: [SocialSentiment]
    let symbol: String
    
    init() {
        self.reddit = []
        self.twitter = []
        self.symbol = NAString
    }
    
    init(reddit: [SocialSentiment], twitter: [SocialSentiment], symbol: String) {
        self.reddit = reddit
        self.twitter = twitter
        self.symbol = symbol
    }
    
    static func example() -> Self {
        return SocialSentimentList(
            reddit: [SocialSentiment.example1(), SocialSentiment.example2()],
            twitter: [SocialSentiment.example3(), SocialSentiment.example4()],
            symbol: "AAPL")
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "social-sentiments/\(stockTicker)")
    }
    
    func APIExample() -> SocialSentimentList {
        return Self.example()
    }
}
