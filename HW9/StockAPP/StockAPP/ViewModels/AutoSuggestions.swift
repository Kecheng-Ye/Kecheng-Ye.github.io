//
//  AutoSuggestions.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/13/22.
//

import Foundation

class AutoSuggestions: GroupQuery {
    @Published var suggestionList = SearchSuggestion()
    var counter = 0
    
    override init() {
        super.init()
        self.name = "AutoSuggestionsQuery"
    }
    
    override func APIServicesInit() {
        APIServices = [
            SingleItemQuery<SearchSuggestion>(data: suggestionList,
                                              update: updateResult)
        ]
    }
    
    func updateResult(newData: SearchSuggestion) {
        counter -= 1
        
        if counter == 0 {
            self.suggestionList.update(new_data: newData)
        }
    }
    
    var suggestions: Array<Suggestion> {
        return suggestionList.suggestions
    }
    
    // MARK: - Intents()
    func startQuery(stockTicker: String) {
        counter += 1
        super.startQuery(for: stockTicker)
    }
    
    func emptyResult() {
        suggestionList.empty()
    }
}
