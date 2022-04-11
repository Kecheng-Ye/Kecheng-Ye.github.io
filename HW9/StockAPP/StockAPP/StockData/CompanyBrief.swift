//
//  CompanyBrief.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct CompanyBrief: Codable {
    let ipo: String
    let finnhubIndustry: String
    let name: String
    let ticker: String
    let weburl: URL?
    let logo: URL?
    
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
    
}
