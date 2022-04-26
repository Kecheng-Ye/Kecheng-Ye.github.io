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
    @Published var isDetailActive = false
    
    init() {
        print("Log: UserProfileVM Constructed")
    }
    
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
    
    func netWorth(priceInfo: [String: CurrentPrice]) -> Price {
        var result = balance
        
        for (ticker, singlePortfolio) in portfolio {
            let revenue = Float(singlePortfolio.sharesRemain) * priceInfo[ticker]!.currentPrice
            
            result += revenue
        }
        
        return result
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
        result.Change       = (currentPrice.currentPrice - result.AverageCost)
        result.MarketValue  = currentPrice.currentPrice * Float(stockRecord.sharesRemain)
        
        return result
    }
    
    // MARK: - Intents()
    func addToWatchlist(for stockTicker: String) {
        userProfile.addToWatchlist(for: stockTicker)
        print("Log: watchlist after add \(watchList) \(watchListSequence)")
        self.objectWillChange.send()
    }
    
    func removeFromWatchlist(for stockTicker: String) {
        userProfile.removeFromWatchlist(for: stockTicker)
        print("Log: watchlist after remove \(watchList) \(watchListSequence)")
        self.objectWillChange.send()
    }
    
    func moveWatchListItem(from Indices: IndexSet, to curr: Int) {
        userProfile.moveWatchListItem(from: Indices, to: curr)
        print("Log: watchlist after move \(watchList) \(watchListSequence)")
        self.objectWillChange.send()
    }
    
    func deleteWatchListItem(for Indices: IndexSet) {
        userProfile.deleteWatchListItem(for: Indices)
        print("Log: watchlist after delete \(watchList) \(watchListSequence)")
        self.objectWillChange.send()
    }
    
    func buyStock(stockTicker: String, record: Trasaction) {
        userProfile.BuyStock(stockTicker: stockTicker, record: record)
        print("Log: portfolio after buy \(portfolio) \(portfolioSequence)")
        self.objectWillChange.send()
    }
    
    func sellStock(stockTicker: String, record: Trasaction) {
        userProfile.SellStock(stockTicker: stockTicker, trans: record)
        print("Log: portfolio after sell \(portfolio) \(portfolioSequence)")
        self.objectWillChange.send()
    }
    
    func movePortfolioItem(from Indices: IndexSet, to curr: Int) {
        userProfile.movePortfolioItem(from: Indices, to: curr)
        print("Log: portfolio after move \(portfolio) \(portfolioSequence)")
        self.objectWillChange.send()
    }
    
    func test() {
        userProfile.addBalance(1)
        self.objectWillChange.send()
    }
}
