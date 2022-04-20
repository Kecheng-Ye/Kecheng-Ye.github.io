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
    
    var body: some View {
        if priceQuery.isLoading || briefQuery.isLoading {
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
        .onAppear(perform: autoUpdateData)
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
        searchBar.initQuery(startSearch: self.autoSuggestions.startQuery)
        searchBar.initCancel(cancelSearch: self.autoSuggestions.emptyResult)
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
