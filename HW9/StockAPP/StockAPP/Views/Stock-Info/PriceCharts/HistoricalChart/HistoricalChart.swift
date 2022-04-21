//
//  HistoricalChart.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/21/22.
//

import SwiftUI

struct HistoricalChart: View {
    let companyBrief: CompanyBrief
    let historicalData: HistoricalRecord
    
    var body: some View {
        WebView(
            fileName: "HistoricalChart",
            fileDirectory: "Charts/HistoricalChart/",
            JSONData: dataToJSON()
        )
    }
    
    func dataToJSON() -> String {
        let (ohlc, volume) = historicalData.toHighChartDraw()
        let ticker = companyBrief.ticker

        let encodedJSON = encodeJSON(
            ["ticker": (ticker, String.self),
             "ohlc": (ohlc, Array<Array<Price>>.self),
             "volume": (volume, Array<Array<Price>>.self)]
        )
        
        return encodedJSON
    }
}

struct HistoricalChart_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalChart(
            companyBrief: CompanyBrief.example(),
            historicalData: HistoricalRecord.example()
        )
    }
}
