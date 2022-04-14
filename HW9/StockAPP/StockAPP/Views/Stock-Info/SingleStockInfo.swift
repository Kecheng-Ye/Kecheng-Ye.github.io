//
//  SingleStockInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import SwiftUI

struct SingleStockInfo: View {
    let stockTicker: String
    @ObservedObject var stockQuery = StockQuery()
    
    init(stockTicker: String) {
        self.stockTicker = stockTicker
        self.stockQuery.isLoading = true
    }
    
    var body: some View {
        if stockQuery.isLoading {
            LoadingView().onAppear(perform: {
                stockQuery.startQuery(for: stockTicker)
            })
        } else {
            let readyInfo = stockQuery.stockData
            VStack {
                StockTitleView(companyBrief: readyInfo.companyBrief,
                               currentPrice: readyInfo.currentPrice)
            }
        }
    }
    
    
}

struct SingleStockInfo_Previews: PreviewProvider {
    static var previews: some View {
        SingleStockInfo(stockTicker: "AAPL")
    }
}
