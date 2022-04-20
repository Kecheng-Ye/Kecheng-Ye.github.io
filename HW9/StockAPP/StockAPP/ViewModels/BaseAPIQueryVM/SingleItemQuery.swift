//
//  SingleItemQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/12/22.
//

import Foundation

protocol Serviceable {
    func startQuery(stockTicker: String, group: DispatchGroup)
}

class SingleItemQuery<T: APILinkable & APIDebugable & Codable>: Serviceable {
    var data: T
    let updateFunc: (T) -> Void
    var errorMessage: String? = nil
    
    init(data: T, update: @escaping (T) -> Void) {
        self.data = data
        self.updateFunc = update
    }
    
    func startQuery(stockTicker: String, group: DispatchGroup) {
        if DEBUG {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.updateFunc(self.data.APIExample())
                group.leave()
            })
        } else {
            let APIFetcher = APIService()
            
            APIFetcher.fetch(T.self, url: data.API_URL(stockTicker: stockTicker), completion: {result in
                DispatchQueue.main.async {
                    defer {
                        group.leave()
                    }
                    
                    switch result {
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            print("Log: API error with \(error)")
                        case .success(let result):
//                            print("--- sucess with \(result)")
                            self.updateFunc(result)
                    }
                }
            })
        }
    }
}

class SingleItemDependentQuery<T: APILinkable & APIDebugable & Codable & Dependable>: SingleItemQuery<T> {
    let myWaitQueue: DispatchGroup = DispatchGroup()
    let semaphore: DispatchSemaphore
    let serialQueue = DispatchQueue(label: "Serial queue")
    let getDependent: () -> T.DependDataType
    
    init(data: T, update: @escaping (T) -> Void,
         getUpdatedDependent: @escaping () -> T.DependDataType,
         semaphore: DispatchSemaphore) {
        self.semaphore = semaphore
        self.getDependent = getUpdatedDependent
        super.init(data: data, update: update)
    }
    
    override func startQuery(stockTicker: String, group: DispatchGroup) {
        serialQueue.async {
            self.semaphore.wait()
            self.data.updateDependData(data: self.getDependent())
            super.startQuery(stockTicker: stockTicker, group: group)
        }
    }
}


