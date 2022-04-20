//
//  MultipleTickerQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/19/22.
//

import Foundation

class MultipleTickerQuery<T: Codable & APILinkable & APIDebugable & ReflectedStringConvertible & NAInitable>: GroupQuery {
    var InfoList: [String: T] = [:]
    
    override init() {
        super.init()
    }
    
    func APIServicesInit(watcListTickers: [String], portfolioTickers: [String]) -> [String] {
        APIServices = []
        let uniqueTickers = Set(watcListTickers + portfolioTickers)
        var result = [String]()
        
        for ticker in uniqueTickers {
            APIServices.append(SingleItemQuery<T>(data: T(), update: update(stockTicker: ticker)))
            result.append(ticker)
        }
        
        return result
    }

    func update(stockTicker: String) -> (T) -> Void {
        return { value in
            self.InfoList[stockTicker]  = value
        }
    }

    // MARK: - Intents()
    func startQuery(watcListTickers: [String], portfolioTickers: [String], updateLoad: Bool = true) {
        let uniqueTickerList = APIServicesInit(watcListTickers: watcListTickers, portfolioTickers: portfolioTickers)
        
        super.startQuery(for: uniqueTickerList, updateLoad: updateLoad, postQuery: {
            self.objectWillChange.send()
        })
    }
    
    func updateOneStock(for stockTicker: String) {
        APIServices = [SingleItemQuery<T>(data: T(), update: update(stockTicker: stockTicker))]
        let uniqueTickerList = [stockTicker]
        
        super.startQuery(for: uniqueTickerList, updateLoad: false, postQuery: {
            self.objectWillChange.send()
        })
    }
    
    subscript(stockTicker: String) -> T {
        InfoList[stockTicker] ?? T()
    }
}
