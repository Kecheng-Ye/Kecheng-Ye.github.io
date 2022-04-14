//
//  MainPageView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import SwiftUI

struct MainPageView: View {
    @EnvironmentObject var search: AutoSuggestions
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        if !isSearching {
            Form {
                Text("Portfolio")
                Text("Favourite")
            }.onAppear(perform: {
                search.emptyResult()
            })
        } else {
            SuggestionListView(suggestions: self.search.suggestions)
        }
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView().environmentObject(AutoSuggestions())
    }
}
