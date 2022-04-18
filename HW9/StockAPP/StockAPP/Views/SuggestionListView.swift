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
        ZStack {
            Color.init(UIColor.lightGray)
            
            VStack {
                List(suggestions, id: \.self) { eachSuggestion in
                    oneSuggestion(eachSuggestion: eachSuggestion)
                }
            }
        }
    }
}

struct oneSuggestion: View {
    let eachSuggestion: Suggestion
    
    var body: some View {
        NavigationLink(destination: SingleStockInfo(stockTicker: eachSuggestion.symbol)) {
            VStack(alignment: .leading) {
                Text(eachSuggestion.symbol).fontWeight(.bold)
                Text(eachSuggestion.description).foregroundColor(.gray)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionListView(suggestions: SearchSuggestion.example().suggestions)
    }
}
