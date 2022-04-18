//
//  BriefQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/17/22.
//

import Foundation

class BriefQuery: GroupQuery {
    @Published var briefInfoList: [String: CompanyBrief] = [:]
    @Published var needRefresh = false
    
    override init() { }
    
    func APIServicesInit(watcListTickers: [String], portfolioTickers: [String]) -> [String] {
        APIServices = []
        let uniqueTickers = Set(watcListTickers + portfolioTickers)
        var result = [String]()
        
        for ticker in uniqueTickers {
            APIServices.append(SingleItemQuery<CompanyBrief>(data: CompanyBrief(), update: update(stockTicker: ticker)))
            result.append(ticker)
        }
        
        return result
    }

    func update(stockTicker: String) -> (CompanyBrief) -> Void {
        return { value in
            self.briefInfoList[stockTicker]  = value
        }
    }

    // MARK: - Intents()
    func startQuery(watcListTickers: [String], portfolioTickers: [String], updateLoad: Bool = true) {
        let uniqueTickerList = APIServicesInit(watcListTickers: watcListTickers, portfolioTickers: portfolioTickers)
        
        super.startQuery(for: uniqueTickerList, updateLoad: updateLoad, postQuery: {
//            print(self.briefInfoList)
            self.needRefresh = false
        })
    }
    
    subscript(stockTicker: String) -> CompanyBrief? {
        briefInfoList[stockTicker]
    }
}
