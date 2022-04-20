//
//  FavoritesView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    let endTimer: () -> Void
    
    var body: some View {
        ForEach(userProfileVM.watchListSequence, id: \.self) { ticker in
            NavigationLink(destination: SingleStockInfo(stockTicker: ticker).onAppear(perform: endTimer)) {
                oneFavorites(stockTicker: ticker)
            }
        }
        .onMove(perform: userProfileVM.moveWatchListItem)
        .onDelete(perform: userProfileVM.deleteWatchListItem)
    }
}

struct oneFavorites: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    let stockTicker: String
    
    var body: some View {
        let brief = briefQuery[stockTicker]
        let price = priceQuery[stockTicker]
        
        HStack {
            VStack(alignment: .leading) {
                Text(stockTicker).font(.title2).fontWeight(.bold)
                Text(brief.name).foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(roundToTwoDecimal(price.currentPrice))").fontWeight(.bold)
                HStack(spacing: 5) {
                    priceArrow(price.priceChange)
                    Text("\(roundToTwoDecimal(price.priceChange))(\(roundToTwoDecimal(price.priceChangePercent))%)")
                }
                .stockColorify(priceChange: price.priceChange)
            }
        }
    }
}
