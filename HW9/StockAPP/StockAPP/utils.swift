//
//  utils.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation
import SwiftUI

typealias Price = Float32

let APILink = "http://kecheng-ye-hw8.us-east-1.elasticbeanstalk.com/api/"

func timestampToString(_ datetime: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = SingleNews.dateFormat
    return dateFormatter.string(from: Date(timeIntervalSince1970: datetime))
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
