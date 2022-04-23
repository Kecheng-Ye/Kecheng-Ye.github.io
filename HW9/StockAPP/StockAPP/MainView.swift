//
//  ContentView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject var autoSuggestions = AutoSuggestions()
    @StateObject var userProfileVM = UserProfileVM()
    @StateObject var priceQuery = PriceQuery()
    @StateObject var briefQuery = BriefQuery()
    @StateObject var searchBar = SearchBar()
    @State var isTimerStop: Bool = false
    var debounce = Debouncer(delay: SEARCH_DEBOUNCE_DELAY)
    var isPageReady: Bool {
        return !(priceQuery.isLoading || briefQuery.isLoading || !isTimerStop)
    }
    
    var body: some View {
        if !isPageReady {
            loadingPage
        } else {
            readyPage
        }
    }
    
    var loadingPage: some View {
        ZStack {
            Color("backgroundGray")
            Image("app icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
        }
        .ignoresSafeArea()
        .onAppear(perform: launchScreenInit)
    }
    
    var readyPage: some View {
        NavigationView {
            MainPageView(isSearching: self.searchBar.isSearching)
                .toolbar { EditButton() }
                .add(self.searchBar)
                .navigationTitle("Stocks")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: mainPageInit)
        .environmentObject(userProfileVM)
        .environmentObject(autoSuggestions)
        .environmentObject(priceQuery)
        .environmentObject(briefQuery)
    }
    
    func mainPageInit() {
        searchBarFuncInit()
    }
    
    func searchBarFuncInit() {
        searchBar.initQuery(startSearch: debounceSearch)
        searchBar.initCancel(cancelSearch: cancelSearch)
    }
    
    func debounceSearch(ticker: String) {
        debounce.run {
            self.autoSuggestions.startQuery(stockTicker: ticker)
        }
    }
    
    func cancelSearch() {
        debounce.cancel()
        self.autoSuggestions.emptyResult()
    }
    
    func launchScreenInit() {
        startTimer()
        autoUpdateData()
    }
    
    func autoUpdateData() {
        priceQuery.startQuery(
            watcListTickers: userProfileVM.watchListSequence,
            portfolioTickers: userProfileVM.portfolioSequence
        )
        
        briefQuery.startQuery(
            watcListTickers: userProfileVM.watchListSequence,
            portfolioTickers: userProfileVM.portfolioSequence
        )
    }
    
    func startTimer() {
        isTimerStop = false
        
        Timer.scheduledTimer(withTimeInterval: SLPASH_SCREEN_DURATION, repeats: false) { timer in
            isTimerStop = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
