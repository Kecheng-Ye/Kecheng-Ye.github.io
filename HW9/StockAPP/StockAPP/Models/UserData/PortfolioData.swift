//
//  PortfolioData.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import Foundation

struct SingleStockPortfolio: Codable {
    var sharesRemain: Int
    var records: [Trasaction]
    var index: Int
    
    enum CodingKeys: CodingKey {
        case sharesRemain
        case records
        case index
    }
    
    init() {
        self.sharesRemain = 0
        self.records = []
        self.index = -1
    }
    
    init(sharesRemain: Int, records: [Trasaction]) {
        self.sharesRemain = sharesRemain
        self.records = records
        self.index = 0
    }
    
    init(sharesRemain: Int, records: [Trasaction], index: Int) {
        self.sharesRemain = sharesRemain
        self.records = records
        self.index = index
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sharesRemain = try container.decode(Int.self, forKey: .sharesRemain)
        self.records = try container.decode([Trasaction].self, forKey: .records)
        self.index = try container.decode(Int.self, forKey: .index)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sharesRemain, forKey: .sharesRemain)
        try container.encode(records, forKey: .records)
        try container.encode(index, forKey: .index)
    }
    
    func changeIdx(newIndex: Int) -> Self {
        return SingleStockPortfolio(sharesRemain: self.sharesRemain, records: self.records, index: newIndex)
    }
    
    static func example1() -> Self {
        return SingleStockPortfolio(sharesRemain: 0, records: [])
    }
    
    static func example2() -> Self {
        return SingleStockPortfolio(
            sharesRemain: 2,
            records: [Trasaction(price: 150, shares: 1), Trasaction(price: 160, shares: 1)]
        )
    }
}

struct Trasaction: Codable {
    var price: Price
    var shares: Int
    
    enum CodingKeys: CodingKey {
        case price
        case shares
    }

    init(price: Price, shares: Int) {
        self.price = price
        self.shares = shares
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(Price.self, forKey: .price)
        self.shares = try container.decode(Int.self, forKey: .shares)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(price, forKey: .price)
        try container.encode(shares, forKey: .shares)
    }
}
