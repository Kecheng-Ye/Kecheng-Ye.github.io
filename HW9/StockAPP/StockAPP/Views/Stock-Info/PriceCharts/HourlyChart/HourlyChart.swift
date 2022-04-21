//
//  HourlyChart.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/20/22.
//

import SwiftUI
import WebKit

struct HourlyChart: View {
    let companyBrief: CompanyBrief
    let currentPrice: CurrentPrice
    let hourlyPrice: HourlyPrice
    
    var body: some View {
        WebView(
            fileName: "HourlyPrice",
            fileDirectory: "Charts/HourlyChart/",
            JSONData: dataToJSON()
        )
    }
    
    func dataToJSON() -> String {
        let plotData = hourlyPrice.toHighChartDraw()
        let color = currentPrice.priceChange > 0 ? "green" : currentPrice.priceChange < 0 ? "red" : "black"
        let ticker = companyBrief.ticker
    
        let encodedJSON = encodeJSON(
            ["ticker": (ticker, String.self),
             "hourly_price": (plotData, Array<Array<Price>>.self),
             "color": (color, String.self)]
        )
        
        return encodedJSON
    }
}

struct HourlyChart_Previews: PreviewProvider {
    static var previews: some View {
        HourlyChart(
            companyBrief: CompanyBrief.example(),
            currentPrice: CurrentPrice.example2(),
            hourlyPrice: HourlyPrice.example()
        )
    }
}
