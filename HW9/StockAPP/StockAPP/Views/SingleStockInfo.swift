//
//  SingleStockInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import SwiftUI

struct SingleStockInfo: View {
    let stockTicker: String
    var comeFromFav: Bool = false
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    @StateObject var stockQuery = StockQuery()
    @Environment(\.presentationMode) var presentationMode
    
    init(stockTicker: String) {
        self.stockTicker = stockTicker
    }
    
    init(stockTicker: String, comeFromFav: Bool) {
        self.stockTicker = stockTicker
        self.comeFromFav = true
    }
    
    var body: some View {
        if stockQuery.isLoading {
            LoadingView().onAppear(perform: {
                stockQuery.startQuery(for: stockTicker)
            })
        } else {
            readyContent
        }
    }
    
    @ViewBuilder
    var readyContent: some View {
        let readyInfo = stockQuery.stockData
        
        GeometryReader { geomtry in
            ScrollView(.vertical) {
                VStack {
                    StockTitleView(
                        companyBrief: readyInfo.companyBrief,
                        currentPrice: readyInfo.currentPrice
                    )
                    .sectionfy()
                    
                    StockPortfolioView(
                        companyBrief: readyInfo.companyBrief,
                        currentPrice: readyInfo.currentPrice
                    )
                    .sectionfy()
                    
                    StatsView(
                        currentPrice: readyInfo.currentPrice
                    )
                    .sectionfy()
                    
                    AboutView(
                        companyBrief: readyInfo.companyBrief,
                        peers: readyInfo.peers
                    )
                    .sectionfy()
                    
                    InsightsView(
                        socialSentiments: readyInfo.socialSentiments,
                        companyBrief: readyInfo.companyBrief
                    )
                    .sectionfy()
                    
                    NewsView(news: readyInfo.news).sectionfy().environmentObject(stockQuery)
                }
                .padding(.horizontal, margin(for: geomtry.size.width))
            }
            .navigationTitle(readyInfo.companyBrief.ticker)
            .navigationBarItems(
                trailing: watchListBtn
            )
        }
    }
    
    @ViewBuilder
    var watchListBtn: some View {
        if userProfileVM.isStockInWatchList(for: stockTicker) {
            removeWatchListBtn
        } else {
            addWatchListBtn
        }
    }
    
    func freshMainPage() {
        priceQuery.needRefresh = true
        briefQuery.needRefresh = true
    }
    
    var addWatchListBtn: some View {
        Button(action: {
            userProfileVM.addToWatchlist(for: stockTicker)
            freshMainPage()
        }) {
            Image(systemName: "plus.circle")
        }
    }
    
    var removeWatchListBtn: some View {
        Button(action: {
            userProfileVM.removeFromWatchlist(for: stockTicker)
            if comeFromFav {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Image(systemName: "plus.circle.fill")
        }
    }
}

struct SingleStockInfo_Previews: PreviewProvider {
    static var previews: some View {
        SingleStockInfo(stockTicker: "AAPL").environmentObject(UserProfileVM())
    }
}
