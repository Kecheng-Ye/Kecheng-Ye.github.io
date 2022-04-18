//
//  PriceQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import Foundation

class PriceQuery: GroupQuery {
    @Published var priceInfoList: [String: CurrentPrice] = [:]
    @Published var needRefresh = false
    
    override init() { }
    
    func APIServicesInit(watcListTickers: [String], portfolioTickers: [String]) -> [String] {
        APIServices = []
        let uniqueTickers = Set(watcListTickers + portfolioTickers)
        var result = [String]()
        
        for ticker in uniqueTickers {
            APIServices.append(SingleItemQuery<CurrentPrice>(data: CurrentPrice(), update: update(stockTicker: ticker)))
            result.append(ticker)
        }
        
        return result
    }

    func update(stockTicker: String) -> (CurrentPrice) -> Void {
        return { value in
            self.priceInfoList[stockTicker]  = value
        }
    }

    // MARK: - Intents()
    func startQuery(watcListTickers: [String], portfolioTickers: [String], updateLoad: Bool = true) {
        let uniqueTickerList = APIServicesInit(watcListTickers: watcListTickers, portfolioTickers: portfolioTickers)
        
        super.startQuery(for: uniqueTickerList, updateLoad: updateLoad, postQuery: {
//            print(self.priceInfoList)
            self.needRefresh = false
        })
    }
    
    subscript(stockTicker: String) -> CurrentPrice? {
        priceInfoList[stockTicker]
    }
}
