//
//  SearchBar.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/13/22.
//

import SwiftUI

struct SuggestionListView: View {
    let suggestions: [Suggestion]

    init(suggestions: [Suggestion]) {
        self.suggestions = suggestions
    }
    
    var body: some View {
        VStack {
            List(suggestions, id: \.self) { eachSuggestion in
                NavigationLink(destination: SingleStockInfo(stockTicker: eachSuggestion.symbol)) {
                    VStack(alignment: .leading) {
                        Text(eachSuggestion.symbol).fontWeight(.bold)
                        Text(eachSuggestion.description).foregroundColor(.gray)
                    }
                }
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionListView(suggestions: SearchSuggestion.example().suggestions)
    }
}
