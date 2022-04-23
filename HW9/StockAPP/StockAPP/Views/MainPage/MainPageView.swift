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
    
    init(isSearching: Bool) {
        self.isSearching = isSearching
        print("Log: Main Page get constructed")
    }
    
    var body: some View {
        if !isSearching {
            Form {
                dateSection
                portfolioSection
                favoritesSection
                finnhubAckSection
            }
            .onAppear(perform: {
                startTimer()
                search.emptyResult()
            })
        } else {
            SuggestionListView(suggestions: self.search.suggestions).onAppear(perform: endTimer)
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
            FavoritesView(endTimer: endTimer)
        }
    }
    
    var portfolioSection: some View {
        Section(header: Text("PORTFOLIO")) {
            PortfolioView(endTime: endTimer)
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
        print("Log: Timer Start")
        isTimerStop = false
        
        Timer.scheduledTimer(withTimeInterval: MAIN_PAGE_AUTO_UPDATE_INTERVAL, repeats: true) { timer in
            if isTimerStop {
                print("Log: Timer fire cancelled")
                timer.invalidate()
                return
            }
            
            print("Log: Timer fire succeed")
            autoUpdateData()
        }
    }
    
    func endTimer() {
        print("Log: Timer ends")
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
