//
//  AutoSuggestions.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/13/22.
//

import Foundation

class AutoSuggestions: ObservableObject {
    @Published var stockTicker: String = ""
    @Published var suggestionList = SearchSuggestion()
    @Published var isLoading = false
    var APIServices: [Serviceable] = []
    
    init() {
        APIServicesInit()
    }
    
    func APIServicesInit() {
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
    func startQuery() {
        let group = DispatchGroup()
        isLoading = true
        
        for service in APIServices {
            group.enter()
            service.startQuery(stockTicker: stockTicker.uppercased(), group: group)
        }
        
        group.notify(queue: .main, execute: {
            self.isLoading = false
        })
    }
    
    func emptyResult() {
        suggestionList.empty()
    }
}
