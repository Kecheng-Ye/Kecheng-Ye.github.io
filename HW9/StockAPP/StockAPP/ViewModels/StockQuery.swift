//
//  StockQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import Foundation

class StockQuery: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var stockData = StockInfo()
    var APIServices: [Serviceable] = []
    let semaphore = DispatchSemaphore(value: 0)
    var currentTime = NATime
    
    init() {
        APIServicesInit()
    }
    
    func APIServicesInit() {
        APIServices = [
            SingleItemQuery<CompanyBrief>(data: stockData.companyBrief,
                                          update: update(propertyName: "companyBrief")),
            SingleItemQuery<CurrentPrice>(data: stockData.currentPrice,
                                          update: { value in
                                              self.currentTime = value.timestamp
                                              self.semaphore.signal()
                                              self.update(propertyName: "currentPrice")(value)
                                          }),
            SingleItemDependentQuery<HourlyPrice>(data: stockData.hourlyPrice,
                                                  update: update(propertyName: "hourlyPrice"),
                                                  getUpdatedDependent: self.getUpdatedTime,
                                                  semaphore: semaphore),
            SingleItemQuery<Peers>(data: stockData.peers,
                                          update: update(propertyName: "peers")),
            SingleItemQuery<News>(data: stockData.news,
                                          update: update(propertyName: "news")),
            SingleItemQuery<HistoricalRecord>(data: stockData.historicRecord,
                                          update: update(propertyName: "historicRecord")),
            SingleItemQuery<RecommendInfos>(data: stockData.recommendInfos,
                                          update: update(propertyName: "recommendInfos")),
            SingleItemQuery<EarningInfos>(data: stockData.earningInfos,
                                          update: update(propertyName: "earningInfos")),
            SingleItemQuery<SocialSentimentList>(data: stockData.socialSentiments,
                                          update: update(propertyName: "socialSentiments")),
        ]
    }
    
    func update<T>(propertyName: String) -> (T) -> Void {
        return { value in
            self.stockData.updateProperty(name: propertyName, value: value as AnyObject)
        }
    }
    
    func getUpdatedTime() -> TimeInterval {
        return self.currentTime
    }
    
    func startQuery(for stockTicker: String) {
        let group = DispatchGroup()
        isLoading = true
        
        for service in APIServices {
            group.enter()
            service.startQuery(stockTicker: stockTicker, group: group)
        }
        
        group.notify(queue: .main, execute: {
            self.isLoading = false
            print("All Tasks finished")
        })
    }
}
