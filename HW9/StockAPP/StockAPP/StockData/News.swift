//
//  News.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct SingleNews: Codable, Identifiable, ReflectedStringConvertible {
    let id: Int64
    let source: String
    let headline: String
    let summary: String
    let url: URL?
    let image: URL?
    let datetime: TimeInterval
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case datetime
        case headline
        case summary
        case url
        case image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int64.self, forKey: .id)
        source = try values.decode(String.self, forKey: .source)
        headline = try values.decode(String.self, forKey: .headline)
        summary = try values.decode(String.self, forKey: .summary)
        url = try? values.decode(URL.self, forKey: .url)
        image = try? values.decode(URL.self, forKey: .image)
        datetime = try values.decode(TimeInterval.self, forKey: .datetime)
        date = timestampToString(datetime)
    }

    init(id: Int64, source: String, headline: String, summary: String, url: URL?, image: URL?, datetime: TimeInterval){
        self.id = id
        self.source = source
        self.headline = headline
        self.summary = summary
        self.url = url
        self.image = image
        self.datetime = datetime
        self.date = timestampToString(datetime)
    }
    
    static let dateFormat = "MMM d, yyyy"
    
    static func example1() -> SingleNews {
        SingleNews(
            id: 109072509,
            source: "Yahoo",
            headline: "Dow Jones Futures: Market Rally Ailing, But These Stocks Are Healthy; Tesla Forges New Entry",
            summary: "The market rally is increasingly split. Tesla reversed lower, but has a handle. Callon leads stocks trading tightly.",
            url: URL(string: "https://finnhub.io/api/news?id=6fced1b8122e6f6b7e9bc9c252f425fd51c406e24779451e1d2a0b49ffb8207f"),
            image: nil,
            datetime: 1649611504.0
        )
    }
    
    static func example2() -> SingleNews {
        SingleNews(
            id: 109067745,
            source: "Yahoo",
            headline: "3 Powerful Stocks That Can Beat Inflation",
            summary: "These businesses have strong pricing power, which should make their stocks excellent hedges against inflation for investors.",
            url: URL(string: "https://finnhub.io/api/news?id=16cc393a20511af15dca85bd852b6216a13d06efc69786a49fd1d12a91b0a900"),
            image: URL(string: "https://s.yimg.com/ny/api/res/1.2/G1IfsIg27QjpiniXa7EizQ--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02NzU-/https://s.yimg.com/uu/api/res/1.2/PeUoVw9vH5ZgM4lQx8zJmA--~B/aD05MzQ7dz0xNDAwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/motleyfool.com/db1bc5c03441f5be744b4cbe00050097"),
            datetime: 1649588400.0
        )
    }
}

typealias News = [SingleNews]

func newsExample() -> News {
    return [SingleNews.example1(), SingleNews.example2()]
}
