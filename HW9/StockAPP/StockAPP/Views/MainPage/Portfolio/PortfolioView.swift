//
//  PortfolioView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    let endTime: () -> Void
    
    var body: some View {
        balanceBrief
        
        ForEach(userProfileVM.portfolioSequence, id: \.self) { ticker in
            NavigationLink(destination: SingleStockInfo(stockTicker: ticker).onAppear(perform: endTime)) {
                onePortfolio(stockTicker: ticker)
            }
            .isDetailLink(false)
        }
        .onMove(perform: userProfileVM.movePortfolioItem)
    }
    
    var balanceBrief: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Net Worth")
                Text("$\(roundToTwoDecimal(userProfileVM.netWorth(priceInfo: priceQuery.InfoList)))").fontWeight(.bold)
            }
            .font(.title3)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Cash Balance")
                Text("$\(roundToTwoDecimal(userProfileVM.balance))").fontWeight(.bold)
            }
            .font(.title3)
        }
    }
}

struct onePortfolio: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    let stockTicker: String
    
    var body: some View {
        let portfolio = userProfileVM.portfolio[stockTicker] ?? SingleStockPortfolio()
        let currentPrice = priceQuery[stockTicker]
        let priceStats = userProfileVM.calculateCostData(stockRecord: portfolio, currentPrice: currentPrice)
        
        HStack {
            VStack(alignment: .leading) {
                Text(stockTicker).font(.title2).fontWeight(.bold)
                Text("\(portfolio.sharesRemain) shares").foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(roundToTwoDecimal(priceStats.MarketValue))").fontWeight(.bold)
                HStack(spacing: 5) {
                    priceArrow(priceStats.Change)
                    Text("\(roundToTwoDecimal(priceStats.Change *  Float(portfolio.sharesRemain)))(\(roundToTwoDecimal(priceStats.Change/priceStats.AverageCost * 100))%)")
                }
                .stockColorify(priceChange: priceStats.Change)
            }
        }
    }
}
