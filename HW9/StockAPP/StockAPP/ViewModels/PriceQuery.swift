//
//  PriceQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import Foundation

var isMarketOpen: Bool = true

class PriceQuery: MultipleTickerQuery<CurrentPrice> {
    override init() {
        super.init()
        self.name = "PriceQuery"
    }
    
    override func postQuery() {
        for (_, value) in InfoList {
            if isMarketOver(time: value.timestamp) {
                isMarketOpen = false
                break
            }
        }
        
        super.postQuery()
    }
    
    func isMarketOver(time: TimeInterval) -> Bool {
        let diff = Date().timeIntervalSince1970 - time
        let diffInMin = diff / 60
        
        return diffInMin >= 5
    }
}
