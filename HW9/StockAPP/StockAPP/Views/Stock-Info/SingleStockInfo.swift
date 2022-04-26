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
        switch stockQuery.status {
            case .PENDING:
                LoadingView().onAppear(perform: {
                    stockQuery.startQuery(for: stockTicker)
                })
            case .SUCCESS:
                readyContent
            case .FAILED:
                failedPage
        }
    }
    
    var failedPage: some View {
        VStack {
            Text("No data found\nPlease enter a valid ticker!")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(.red)
                .cornerRadius(20)
            
            Button(action:
                    { stockQuery.startQuery(for: stockTicker) }
            ) {
                Text("Reload")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 50)
            }
            .background(Color("backgroundGray"))
            .clipShape(Capsule())
            .padding()
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
                    
                    PriceCharts(
                        companyBrief: readyInfo.companyBrief,
                        historicalData: readyInfo.historicRecord,
                        currentPrice: readyInfo.currentPrice,
                        hourlyPrice: readyInfo.hourlyPrice
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
                        companyBrief: readyInfo.companyBrief,
                        recommendInfos: readyInfo.recommendInfos,
                        earningInfos: readyInfo.earningInfos
                    )
                    .sectionfy()
                    
                    NewsView(
                        news: readyInfo.news
                    )
                    .sectionfy()
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
        priceQuery.updateOneStock(for: stockTicker, data: stockQuery.stockData.currentPrice)
        briefQuery.updateOneStock(for: stockTicker, data: stockQuery.stockData.companyBrief)
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
