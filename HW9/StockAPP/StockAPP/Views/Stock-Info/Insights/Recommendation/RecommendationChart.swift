//
//  RecommendationChart.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/21/22.
//

import SwiftUI

struct RecommendationChart: View {
    let recommendInfos: RecommendInfos
    
    var body: some View {
        WebView(
            fileName: "RecommendInfoChart",
            fileDirectory: "Charts/RecommendInfoChart/",
            JSONData: dataToJSON()
        )
    }
    
    func dataToJSON() -> String {
        let (categories, strongBuy, buy, hold, sell, strongSell) = RecommendInfotoHighChartDraw(recommendInfos)
    
        let encodedJSON = encodeJSON(
            [
                "categories": (categories, Array<String>.self),
                "strongBuy": (strongBuy, Array<Int32>.self),
                "buy": (buy, Array<Int32>.self),
                "hold": (hold, Array<Int32>.self),
                "sell": (sell, Array<Int32>.self),
                "strongSell": (strongSell, Array<Int32>.self),
            ]
        )
        
        return encodedJSON
    }
}

struct RecommendationChart_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationChart(recommendInfos: RecommendInfoList())
    }
}
