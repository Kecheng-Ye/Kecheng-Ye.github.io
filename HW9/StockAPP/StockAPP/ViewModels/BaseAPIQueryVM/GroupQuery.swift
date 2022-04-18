//
//  GroupQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import Foundation

class GroupQuery: ObservableObject {
    @Published var isLoading: Bool = true
    var APIServices: [Serviceable] = []
    
    init() {
        APIServicesInit()
    }
    
    func APIServicesInit() {
        APIServices = []
    }
    
    func startQuery(for stockTicker: String, updateLoad: Bool = true, postQuery: @escaping () -> Void = {}) {
        let group = DispatchGroup()
        if updateLoad {
            isLoading = true
        }
        
        for service in APIServices {
            group.enter()
            service.startQuery(stockTicker: stockTicker, group: group)
        }
        
        group.notify(queue: .main, execute: {
            self.isLoading = false
            print("All Tasks finished")
            postQuery()
        })
    }
    
    func startQuery(for stockTickers: [String], updateLoad: Bool = true, postQuery: @escaping () -> Void = {}) {
        assert(stockTickers.count == APIServices.count,
               "Wrong number of stockTickers: \(stockTickers.count) and APIServices: \(APIServices.count)")
        
        let group = DispatchGroup()
        if updateLoad {
            isLoading = true
        }
        
        for idx in 0..<APIServices.count {
            let service = APIServices[idx]
            let stockTicker = stockTickers[idx]
            group.enter()
            service.startQuery(stockTicker: stockTicker, group: group)
        }
        
        group.notify(queue: .main, execute: {
            self.isLoading = false
            print("All Tasks finished")
            postQuery()
        })
    }
}

