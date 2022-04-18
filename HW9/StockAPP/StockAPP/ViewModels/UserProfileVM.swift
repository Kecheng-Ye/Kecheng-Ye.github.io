//
//  UserProfileVM.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/15/22.
//

import Foundation
import SwiftUI

typealias CostStats = (TotalCost: Price, AverageCost: Price, Change: Price, MarketValue: Price)

class UserProfileVM: ObservableObject  {
    @AppStorage("UserProfile") var userProfile = UserProfile()
    
    var balance: Price {
        userProfile.balance
    }
    
    var watchList: [String: Int] {
        userProfile.watchList
    }
    
    var watchListSequence: [String] {
        userProfile.watchListSequence
    }
    
    var portfolioSequence: [String] {
        userProfile.portfolioSequence
    }
    
    var portfolio: [String: SingleStockPortfolio] {
        userProfile.portfolio
    }
    
    func isStockInWatchList(for stockTicker: String) -> Bool {
        return userProfile.isStockInWatchList(for: stockTicker)
    }
    
    func isStockInPortfolio(for stockTicker: String) -> Bool {
        return userProfile.isStockInPortfolio(for: stockTicker)
    }
    
    func getStockTransactionRecord(for stockTicker: String) -> SingleStockPortfolio {
        if let result = userProfile.portfolio[stockTicker] {
            return result
        } else {
            return SingleStockPortfolio(sharesRemain: 0, records: [])
        }
    }
    
    func calculateCostData(stockRecord: SingleStockPortfolio, currentPrice: CurrentPrice) -> CostStats {
        var result = (TotalCost: Price(0), AverageCost: Price(0), Change: Price(0), MarketValue: Price(0))
        
        for transaction in stockRecord.records {
            result.TotalCost += (Float(transaction.shares) * transaction.price)
        }
        
        result.AverageCost  = result.TotalCost / Float(stockRecord.sharesRemain)
        result.Change       = currentPrice.currentPrice - result.AverageCost
        result.MarketValue  = currentPrice.currentPrice * Float(stockRecord.sharesRemain)
        
        return result
    }
    
    // MARK: - Intents()
    func addToWatchlist(for stockTicker: String) {
        userProfile.addToWatchlist(for: stockTicker)
        self.objectWillChange.send()
    }
    
    func removeFromWatchlist(for stockTicker: String) {
        userProfile.removeFromWatchlist(for: stockTicker)
        self.objectWillChange.send()
    }
    
    func moveWatchListItem(from Indices: IndexSet, to curr: Int) {
        userProfile.moveWatchListItem(from: Indices, to: curr)
        self.objectWillChange.send()
    }
    
    func deleteWatchListItem(for Indices: IndexSet) {
        userProfile.deleteWatchListItem(for: Indices)
        self.objectWillChange.send()
    }
    
    func buyStock(stockTicker: String, record: Trasaction) {
        userProfile.BuyStock(stockTicker: stockTicker, record: record)
        self.objectWillChange.send()
    }
    
    func sellStock(stockTicker: String, record: Trasaction) {
        userProfile.SellStock(stockTicker: stockTicker, trans: record)
        self.objectWillChange.send()
    }
    
    func test() {
        userProfile.addBalance(1)
        self.objectWillChange.send()
    }
}
