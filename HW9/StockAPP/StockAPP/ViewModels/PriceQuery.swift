//
//  PriceQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import Foundation

class PriceQuery: MultipleTickerQuery<CurrentPrice> {
    
    override init() {
        super.init()
        self.name = "PriceQuery"
    }
    
}
