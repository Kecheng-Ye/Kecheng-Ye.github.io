//
//  SingleStockPortfolio.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/15/22.
//

import SwiftUI

struct StockPortfolioView: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    let companyBrief: CompanyBrief
    let currentPrice: CurrentPrice
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Portfolio").subTitlefy()
            fullWidthBinaryHStack(
                left: Info,
                right: TradeButton,
                alignment2: .center
            ).contentfy()
        }
    }
    
    @ViewBuilder
    var Info: some View {
        let stockPortfolio = userProfileVM.getStockTransactionRecord(for: companyBrief.ticker)
        
        if stockPortfolio.sharesRemain == 0 {
            Text("You have 0 shares of \(companyBrief.ticker).\nStart trading")
        } else {
            priceInfo(stockPortfolio: stockPortfolio)
        }
    }
    
    var TradeButton: some View {
        Button(action: {}) {
            Text("Trade").font(.body).foregroundColor(.white).frame(width: 120)
        }
        .padding()
        .background(.green)
        .clipShape(Capsule())
    }
    
    func priceInfo(stockPortfolio: SingleStockPortfolio) -> some View {
        let costStats = userProfileVM.calculateCostData(stockRecord: stockPortfolio, currentPrice: currentPrice)
        
        return (
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Shared Owned: ").fontWeight(.semibold)
                    Text("\(stockPortfolio.sharesRemain)")
                }
                
                HStack {
                    Text("Avg. Cost/Share: ").fontWeight(.semibold)
                    Text("$\(roundToTwoDecimal(costStats.AverageCost))")
                }
                
                HStack {
                    Text("Total Cost: ").fontWeight(.semibold)
                    Text("$\(roundToTwoDecimal(costStats.AverageCost))")
                }
                
                HStack {
                    Text("Change: ").fontWeight(.semibold)
                    Text("$\(roundToTwoDecimal(abs(costStats.Change)))").stockColorify(priceChange: costStats.Change)
                }
                
                HStack {
                    Text("Market Value: ").fontWeight(.semibold)
                    Text("$\(roundToTwoDecimal(costStats.MarketValue))")
                        .stockColorify(priceChange: costStats.Change)
                }
            }
        )
    }
}

struct StockPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockPortfolioView(
            companyBrief: CompanyBrief.example(),
            currentPrice: CurrentPrice.example1()
        ).environmentObject(UserProfileVM())
    }
}
