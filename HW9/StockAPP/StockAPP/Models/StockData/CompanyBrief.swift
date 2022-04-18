//
//  CompanyBrief.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct CompanyBrief: Codable, APILinkable, APIDebugable, ReflectedStringConvertible {
    let ipo: String
    let finnhubIndustry: String
    let name: String
    let ticker: String
    let weburl: URL?
    let logo: URL?
    
    init() {
        self.ipo = NAString
        self.finnhubIndustry = NAString
        self.name = NAString
        self.ticker = NAString
        self.weburl = NAURL
        self.logo = NAURL
    }
    
    init(ipo: String, finnhubIndustry: String, name: String, ticker: String, weburl: URL?, logo: URL?) {
        self.ipo = ipo
        self.finnhubIndustry = finnhubIndustry
        self.name = name
        self.ticker = ticker
        self.weburl = weburl
        self.logo = logo
    }
    
    static func example() -> CompanyBrief {
        CompanyBrief(
            ipo: "1980-12-12",
            finnhubIndustry: "Technology",
            name: "Apple Inc",
            ticker: "AAPL",
            weburl: URL(string: "https://www.apple.com/"),
            logo: URL(string: "https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png")
        )
        
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "brief/\(stockTicker)")
    }
    
    func APIExample() -> CompanyBrief {
        return Self.example()
    }
}
