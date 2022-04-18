//
//  MainPageView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import SwiftUI

struct MainPageView: View {
    @EnvironmentObject var search: AutoSuggestions
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    @State var isTimerStop: Bool = true
    let isSearching: Bool
    
    var body: some View {
        if !isSearching {
            if priceQuery.needRefresh || briefQuery.needRefresh {
                LoadingView().onAppear(perform: autoUpdateData)
            } else {
                Form {
                    dateSection
                    favoritesSection
                    finnhubAckSection
                }
                .onAppear(perform: {
                    startTimer()
                    search.emptyResult()
                })
                .onDisappear(perform: endTimer)
            }
        } else {
            SuggestionListView(suggestions: self.search.suggestions)
        }
    }
    
    var dateSection: some View {
        Section {
            Text(timestampToString(Date().timeIntervalSince1970))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
    }
    
    var favoritesSection: some View {
        Section(header: Text("FAVORITES")) {
            ForEach(userProfileVM.watchListSequence, id: \.self) { ticker in
                NavigationLink(destination: SingleStockInfo(stockTicker: ticker, comeFromFav: true)) {
                    oneFavorites(stockTicker: ticker)
                }
            }
            .onMove(perform: moveWatchListItem)
            .onDelete(perform: deleteWatchListItem)
        }
    }
    
    func moveWatchListItem(prev: IndexSet, curr: Int) {
        userProfileVM.moveWatchListItem(from: prev, to: curr)
    }
    
    func deleteWatchListItem(target: IndexSet) {
        userProfileVM.deleteWatchListItem(for: target)
    }
    
    func oneFavorites(stockTicker: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stockTicker).font(.title2).fontWeight(.bold)
                Text(briefQuery[stockTicker]!.name).foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(roundToTwoDecimal(priceQuery[stockTicker]!.currentPrice))").fontWeight(.bold)
                HStack(spacing: 5) {
                    priceArrow(priceQuery[stockTicker]!.priceChange)
                    Text("\(roundToTwoDecimal(priceQuery[stockTicker]!.priceChange))(\(roundToTwoDecimal(priceQuery[stockTicker]!.priceChangePercent))%)")
                }
                .stockColorify(priceChange: priceQuery[stockTicker]!.priceChange)
            }
        }
    }
    
    var finnhubAckSection: some View {
        Link(destination: URL(string: FinnhubLink)!) {
            Section {
                Text("Powered By Finnhub.io")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fullWidth(alignment: .center)
            }
        }
    }
    
    func autoUpdateData() {
        priceQuery.startQuery(
            watcListTickers: userProfileVM.watchListSequence,
            portfolioTickers: userProfileVM.portfolioSequence,
            updateLoad: false
        )
        
        briefQuery.startQuery(
            watcListTickers: userProfileVM.watchListSequence,
            portfolioTickers: userProfileVM.portfolioSequence,
            updateLoad: false
        )
    }
    
    func startTimer() {
        isTimerStop = false
        
        Timer.scheduledTimer(withTimeInterval: AUTO_UPDATE_INTERVAL, repeats: true) { timer in
            if isTimerStop {
                timer.invalidate()
            }
            
            autoUpdateData()
        }
    }
    
    func endTimer() {
        isTimerStop = true
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView(isSearching: false)
            .environmentObject(AutoSuggestions())
            .environmentObject(UserProfileVM())
            .environmentObject(PriceQuery())
            .environmentObject(BriefQuery())
    }
}
