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
    @Environment(\.isSearching) var isSearching

    var body: some View {
        NavigationView {
            MainPageView().navigationTitle("Stocks")
        }
        .searchable(text: $autoSuggestions.stockTicker)
//        .onReceive(autoSuggestions.$stockTicker.debounce(for: .seconds(1.5), scheduler: DispatchQueue.main)) {
//            guard !$0.isEmpty else { return }
////            autoSuggestions.startQuery()
//            autoSuggestions.suggestionList.update(new_data: SearchSuggestion.example())
//        }
        .onSubmit(of: .search) {
    //                autoSuggestions.startQuery()
            autoSuggestions.suggestionList.update(new_data: SearchSuggestion.example())
        }
        .environmentObject(autoSuggestions)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
