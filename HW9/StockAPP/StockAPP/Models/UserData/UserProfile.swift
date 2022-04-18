//
//  UserProfile.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/15/22.
//

import Foundation

struct UserProfile: Codable, ReflectedStringConvertible {
    var balance: Price
    var watchList: [String: Int]
    var watchListSequence: [String]
    var portfolio: [String: SingleStockPortfolio]
    var portfolioSequence: [String]

    init() {
        self.balance = START_BALANCE
        self.watchList = [:]
        self.watchListSequence = []
        self.portfolio = [:]
        self.portfolioSequence = []
    }
    
    // MARK: - WatchList Related
    func isStockInWatchList(for stockTicker: String) -> Bool {
        return (watchList[stockTicker] != nil)
    }
    
    mutating func addToWatchlist(for stockTicker: String) {
        watchList[stockTicker] = watchListSequence.count
        watchListSequence.append(stockTicker)
    }
    
    mutating func removeFromWatchlist(for stockTicker: String) {
        let idxToRemove = watchList[stockTicker]!
        watchListSequence.remove(at: idxToRemove)
        watchList.removeValue(forKey: stockTicker)
    }
    
    mutating func moveWatchListItem(from prev: IndexSet, to curr: Int) {
        watchListSequence.move(fromOffsets: prev, toOffset: curr)
        updateWatchListSeq()
    }
    
    mutating func deleteWatchListItem(for target: IndexSet) {
        watchListSequence.remove(atOffsets: target)
        updateWatchListSeq()
    }
    
    mutating func updateWatchListSeq() {
        let leftTickers = Set(watchListSequence)
        
        for ticker in watchList.keys {
            if !leftTickers.contains(ticker) {
                watchList.removeValue(forKey: ticker)
            }
        }
        
        var idx = 0
            
            
        for ticker in watchListSequence {
            watchList[ticker] = idx
            idx += 1
        }
    }
    
    // MARK: - Portfolio  Related
    func isStockInPortfolio(for stockTicker: String) -> Bool {
        if let oneStockRecord = portfolio[stockTicker] {
            return oneStockRecord.sharesRemain != 0
        } else {
            return false
        }
    }
    
    mutating func BuyStock(stockTicker: String, record: Trasaction) {
        if portfolio[stockTicker] == nil {
            portfolio[stockTicker] = SingleStockPortfolio(sharesRemain: 0, records: [])
        }
        
        var oneStockTransaction = portfolio[stockTicker]!
        oneStockTransaction.sharesRemain += record.shares;
        oneStockTransaction.records.append(record);
        
        self.portfolio[stockTicker] = oneStockTransaction
        self.balance = self.balance - record.price * Float(record.shares)
    }
    
    mutating func SellStock(stockTicker: String, trans: Trasaction) {
        let targetStockPortfolio = portfolio[stockTicker]!
        let soldPrice = trans.price, soldShares = trans.shares
        var remainShares = targetStockPortfolio.sharesRemain, oldRecords = targetStockPortfolio.records
        
        
        self.balance = self.balance + soldPrice * Float(soldShares);
        
        if remainShares == soldShares {
            self.portfolio.removeValue(forKey: stockTicker)
        } else {
            var tempShares = soldShares, idx = 0
            
            for record in oldRecords {
                if record.shares > tempShares {
                    break
                } else {
                    idx += 1
                    tempShares -= record.shares;
                }
            }
            
            remainShares -= soldShares
            var newRecords = Array(oldRecords[idx...])
            if tempShares != 0 {
                newRecords[0] = Trasaction(price: newRecords[0].price, shares: newRecords[0].shares - tempShares)
            }
            portfolio[stockTicker] = SingleStockPortfolio(sharesRemain: remainShares, records: newRecords)
        }
    }
    
    mutating func addBalance(_ value: Price) {
        balance += value
    }
}


extension UserProfile: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(UserProfile.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return result
    }
}

extension UserProfile {
    enum CodingKeys: CodingKey {
        case balance
        case watchList
        case watchListSequence
        case portfolio
        case portfolioSequence
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.balance = try container.decode(Price.self, forKey: .balance)
        self.watchList = try container.decode([String: Int].self, forKey: .watchList)
        self.watchListSequence = try container.decode([String].self, forKey: .watchListSequence)
        self.portfolio = try container.decode([String: SingleStockPortfolio].self, forKey: .portfolio)
        self.portfolioSequence = try container.decode([String].self, forKey: .portfolioSequence)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(balance, forKey: .balance)
        try container.encode(watchList, forKey: .watchList)
        try container.encode(watchListSequence, forKey: .watchListSequence)
        try container.encode(portfolio, forKey: .portfolio)
        try container.encode(portfolioSequence, forKey: .portfolioSequence)
    }
}
