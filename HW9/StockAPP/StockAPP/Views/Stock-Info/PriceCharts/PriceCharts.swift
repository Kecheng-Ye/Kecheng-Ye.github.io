//
//  PriceCharts.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/21/22.
//

import SwiftUI

struct PriceCharts: View {
    let companyBrief: CompanyBrief
    let historicalData: HistoricalRecord
    let currentPrice: CurrentPrice
    let hourlyPrice: HourlyPrice
    
    var body: some View {
        TabView {
            HourlyChart(
                companyBrief: companyBrief,
                currentPrice: currentPrice,
                hourlyPrice: hourlyPrice
            )
            .tabItem {
                Label("Hourly", systemImage: "chart.xyaxis.line")
            }

            HistoricalChart(
                companyBrief: companyBrief,
                historicalData: historicalData
            )
            .tabItem {
                Label("Historical", systemImage: "clock.fill")
            }
        }
        .frame(
            minHeight: 470
        )
    }
}

struct PriceCharts_Previews: PreviewProvider {
    static var previews: some View {
        PriceCharts(companyBrief: CompanyBrief.example(), historicalData: HistoricalRecord.example(), currentPrice: CurrentPrice.example1(), hourlyPrice: HourlyPrice.example())
    }
}
