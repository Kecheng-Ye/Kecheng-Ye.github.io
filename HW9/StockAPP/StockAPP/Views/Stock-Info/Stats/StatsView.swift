//
//  States.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import SwiftUI

struct StatsView: View {
    let currentPrice: CurrentPrice
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Stats").subTitlefy()
            fullWidthBinaryHStack(left: leftPriceGroup, right: rightPriceGroup).contentfy()
        }
    }
    
    var leftPriceGroup: some View {
        VStack(alignment: .leading, spacing: 15) {
            highPrice
            lowPrice
        }
    }
    
    var rightPriceGroup: some View {
        VStack(alignment: .leading, spacing: 15) {
            openPrice
            prevClose
        }
    }
    
    var highPrice: some View {
        HStack {
            Text("High Price: ").fontWeight(.bold)
            Text("\(roundToTwoDecimal(currentPrice.high))")
        }
    }
    
    var lowPrice: some View {
        HStack {
            Text("Low Price: ").fontWeight(.bold)
            Text("\(roundToTwoDecimal(currentPrice.low))")
        }
    }
    
    var openPrice: some View {
        HStack {
            Text("Open Price: ").fontWeight(.bold)
            Text("\(roundToTwoDecimal(currentPrice.open))")
        }
    }
    
    var prevClose: some View {
        HStack {
            Text("Prev. Close: ").fontWeight(.bold)
            Text("\(roundToTwoDecimal(currentPrice.previousClose))")
        }
    }
}

struct States_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(currentPrice: CurrentPrice.example1())
    }
}
