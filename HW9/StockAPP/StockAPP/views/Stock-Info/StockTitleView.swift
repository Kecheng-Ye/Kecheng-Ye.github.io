//
//  StockTitleView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import SwiftUI

struct StockTitleView: View {
    let companyBrief: CompanyBrief
    let currentPrice: CurrentPrice
    
    var body: some View {
        HStack {
            title
        }
    }
    
    var title: some View {
        VStack(alignment: .leading, spacing: drawingConstant.horizontalSpace) {
            Text(companyBrief.ticker)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(companyBrief.name)
                .foregroundColor(.gray)
            priceInfo
        }
    }
    
    var priceInfo: some View {
        HStack {
            Text("$\(currentPrice.currentPrice, specifier: "%.2f")")
                .font(.largeTitle)
                .fontWeight(.bold)
            Group {
                priceArrow
                Text("\(currentPrice.priceChange, specifier: "%.2f") (\(currentPrice.priceChangePercent, specifier: "%.2f")%)")
            }
            .stockColorify(priceChange: currentPrice.priceChange)
            .font(.title2)
        }
    }
    
    @ViewBuilder
    var priceArrow: some View {
        if currentPrice.priceChange > 0 {
            Image(systemName: "arrow.up.right")
        } else if currentPrice.priceChange < 0 {
            Image(systemName: "arrow.down.left")
        }
    }
    
    private struct drawingConstant {
        static let horizontalSpace: CGFloat = 20
        static let lineWidth: CGFloat = 3
    }
}

struct StockTitleView_Previews: PreviewProvider {
    static var previews: some View {
        StockTitleView(
            companyBrief: CompanyBrief.example(),
            currentPrice: CurrentPrice.example1()
        )
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
