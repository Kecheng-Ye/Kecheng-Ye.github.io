//
//  StockRelatedViews.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import SwiftUI

@ViewBuilder
func priceArrow(_ priceChange: Price) -> some View {
    if priceChange > 0 {
        Image(systemName: "arrow.up.right")
    } else if priceChange < 0 {
        Image(systemName: "arrow.down.left")
    }
}

struct stockColor: ViewModifier {
    let priceChange: Price
    
    func body(content: Content) -> some View {
        content.foregroundColor(
            priceChange > 0 ? .green :
                priceChange < 0 ? .red : .black
        )
    }
}

extension View {
    func stockColorify(priceChange: Price) -> some View {
        self.modifier(stockColor(priceChange: priceChange))
    }
}
