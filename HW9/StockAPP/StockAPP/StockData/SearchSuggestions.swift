//
//  SearchSuggestions.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct Suggestion: Codable {
    let description: String
    let symbol: String
}

struct SearchSuggestion {
    let count: Int32
    let suggestions: [Suggestion]
    
    enum CodingKeys: String, CodingKey {
        case count
        case suggestions = "result"
    }
    
    static func example() -> SearchSuggestion {
        SearchSuggestion(
            count: 6,
            suggestions:
                [
                    Suggestion(description: "APPLE INC", symbol: "AAPL"),
                     Suggestion(description: "APPLE INC", symbol: "AAPL.MX"),
                     Suggestion(description: "LS 1X AAPL", symbol: "AAPL.L"),
                     Suggestion(description: "AA PLC", symbol: "AATDF"),
                     Suggestion(description: "Gaz Capital", symbol: "A1HFY3.MU"),
                     Suggestion(description: "Aviva Plc", symbol: "A2RT8J.BE"),
                ]
        )
    }
}

