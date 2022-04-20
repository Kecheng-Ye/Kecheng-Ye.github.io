//
//  SingleStockInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import SwiftUI

struct SingleStockInfo: View {
    let stockTicker: String
    @State var addWatchlistSuccess: Bool = false
    @State var addWatchlistCounter: Int = 0
    @State var removeWatchlistSuccess: Bool = false
    @State var removeWatchlistCounter: Int = 0
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    @StateObject var stockQuery = StockQuery()
    
    init(stockTicker: String) {
        self.stockTicker = stockTicker
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
            .toast(isShowing: $addWatchlistSuccess, counter: $addWatchlistCounter, text: Text("Adding \(stockTicker) to Favorites"))
            .toast(isShowing: $removeWatchlistSuccess, counter: $removeWatchlistCounter, text: Text("Removing \(stockTicker) from Favorites"))
            .navigationTitle(stockTicker)
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
    
    func MainPageUpdate(for stockTicker: String) {
        priceQuery.updateOneStock(for: stockTicker)
        briefQuery.updateOneStock(for: stockTicker)
    }
    
    var addWatchListBtn: some View {
        Button(action: {
            MainPageUpdate(for: stockTicker)
            userProfileVM.addToWatchlist(for: stockTicker)
            addSuccess()
        }) {
            Image(systemName: "plus.circle")
        }
    }
    
    var removeWatchListBtn: some View {
        Button(action: {
            userProfileVM.removeFromWatchlist(for: stockTicker)
            removeSuccess()
        }) {
            Image(systemName: "plus.circle.fill")
        }
    }
    
    func addSuccess() {
        self.removeWatchlistSuccess = false
        self.addWatchlistSuccess = true
        self.addWatchlistCounter += 1
    }
    
    func removeSuccess() {
        self.removeWatchlistSuccess = true
        self.removeWatchlistCounter += 1
        self.addWatchlistSuccess = false
    }
}

struct SingleStockInfo_Previews: PreviewProvider {
    static var previews: some View {
        SingleStockInfo(stockTicker: "AAPL").environmentObject(UserProfileVM())
    }
}
