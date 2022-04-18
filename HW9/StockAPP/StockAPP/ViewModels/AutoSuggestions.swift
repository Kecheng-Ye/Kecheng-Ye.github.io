//
//  AutoSuggestions.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/13/22.
//

import Foundation

class AutoSuggestions: GroupQuery {
    @Published var suggestionList = SearchSuggestion()
    
    override func APIServicesInit() {
        APIServices = [
            SingleItemQuery<SearchSuggestion>(data: suggestionList,
                                              update: { newData in
                                                  self.suggestionList.update(new_data: newData)
                                              })
        ]
    }
    
    var suggestions: Array<Suggestion> {
        return suggestionList.suggestions
    }
    
    // MARK: - Intents()
    func startQuery(stockTicker: String) {
        super.startQuery(for: stockTicker)
    }
    
    func emptyResult() {
        suggestionList.empty()
    }
}
