//
//  BriefQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/17/22.
//

import Foundation

class BriefQuery: MultipleTickerQuery<CompanyBrief> {
    
    override init() {
        super.init()
        self.name = "BriefQuery"
    }
    
}

