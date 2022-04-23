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
    
    func hasNilValue() -> Bool {
        return (
            source == NAString ||
            headline == NAString ||
            summary == NAString ||
            url == nil ||
            image == nil
        )
    }
    
    func calculateTimeDiff() -> String {
        let diff = Date().timeIntervalSince1970 - self.datetime
        let hours = Int(diff / 3600)
        let minutes = Int((diff - Double(hours * 3600)) / 60)
        
        return String(format: "%d hr, %d min", hours, minutes)
    }
    
    func twitterShareURL() -> URL {
        let shareString = "https://twitter.com/share?title=\(self.headline)&url=\(self.url!.absoluteString)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        return URL(string: escapedShareString)!
    }
    
    func facebookShareURL() -> URL {
        let shareString = "https://www.facebook.com/sharer/sharer.php?u=\(self.url!.absoluteString)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        return URL(string : escapedShareString)!
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
    
    static func example3() -> SingleNews {
        SingleNews(
            id: 107388525,
            source: "SeekingAlpha",
            headline: "Discovery: Promising Potential Upon Materialization Of WarnerMedia Deal",
            summary: "Although the Discovery has been demonstrating resilience through a volatile market climate, remaining significantly undervalued. See more on DISCA stock here.",
            url: URL(string: "https://finnhub.io/api/news?id=13e63382cfdb0a2c1312094b86141d405f88c2e621e12974fbc812a870cd8507"),
            image: URL(string: "https://media.gettyimages.com/photos/view-of-food-network-at-the-blue-moon-burger-bash-presented-by-pat-picture-id1346637907?b=1&k=20&m=1346637907&s=594x594&w=0&h=DqBXIoknqQPoW73iT2YPrbsWWt2Ta6PLNXsiHNQS4KY="),
            datetime: 1647342174.0
        )
    }
    
    static func example4() -> SingleNews {
        SingleNews(
            id: 107362525,
            source: "Finnhub",
            headline: "Apple : Impact Accelerator unlocks new opportunities for US businesses",
            summary: "FEATUREMarch 15, 2022 Apple's Impact Accelerator unlocks new opportunities for US businesses to speed environmental progress ... | March 15, 2022",
            url: URL(string: "https://finnhub.io/api/news?id=4b2d4d508819e7c8822ae1229fba1fc86b91da4da5cb70cdd89259689c4a3552"),
            image: URL(string: ""),
            datetime: 1647334937.0
        )
    }
    
    static func example5() -> SingleNews {
        SingleNews(
            id: 107338958,
            source: "Nasdaq",
            headline: "1 Green Flag and 1 Red Flag for Masimo",
            summary: "Just when you think investing in healthcare companies might be the place for investors to hide out during a bear market, a company goes and does something that leaves more questions than answers. And when that happens, you get a sell-off caused by fear of the unknown.",
            url: URL(string: "https://finnhub.io/api/news?id=0e0d0a823162a83291885ff3ae81ed2331429f59f2e4b1c58d1eb7a5525395f7"),
            image: URL(string: "https://www.nasdaq.com/sites/acquia.prod/files/2019-05/0902-Q19%20Total%20Markets%20photos%20and%20gif_CC8.jpg?1793683521"),
            datetime: 1647328560.0
        )
    }
}

typealias News = [SingleNews]

func newsExample() -> News {
    return [SingleNews.example1(), SingleNews.example2(), SingleNews.example3(), SingleNews.example4(), SingleNews.example5()]
}

func filterNews(rawNewsList: News) -> News {
    var count = 0
    var result = News()
    
    for singleNews in rawNewsList {
        
        if !singleNews.hasNilValue() {
            result.append(singleNews)
            count += 1
        }
        
        if count == NEWS_LIMIT {
            break
        }
    }
    
    return result
}
