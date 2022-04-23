//
//  StockQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import Foundation

enum STATUS {
    case PENDING
    case SUCCESS
    case FAILED
}

class StockQuery: GroupQuery {
    var stockData = StockInfo()
    @Published var status: STATUS = .PENDING
    let semaphore = DispatchSemaphore(value: 0)
    var currentTime = NATime
    
    override init() {
        super.init()
        self.name = "StockQuery"
    }
    
    override func APIServicesInit() {
        APIServices = [
            SingleItemQuery<CompanyBrief>(data: stockData.companyBrief,
                                          update: update(propertyName: "companyBrief"),
                                          fail: singleQueryFailed),
            
            SingleItemQuery<CurrentPrice>(data: stockData.currentPrice,
                                          update: { value in
                                              self.currentTime = value.timestamp
                                              self.semaphore.signal()
                                              self.update(propertyName: "currentPrice")(value)
                                          },
                                          fail: singleQueryFailed),
            
            SingleItemDependentQuery<HourlyPrice>(data: stockData.hourlyPrice,
                                                  update: update(propertyName: "hourlyPrice"),
                                                  getUpdatedDependent: self.getUpdatedTime,
                                                  semaphore: semaphore),
            
            SingleItemQuery<Peers>(data: stockData.peers,
                                   update: update(propertyName: "peers"),
                                   fail: singleQueryFailed),
            
            SingleItemQuery<News>(data: stockData.news,
                                  update: update(propertyName: "news"),
                                  fail: singleQueryFailed),
            
            SingleItemQuery<HistoricalRecord>(data: stockData.historicRecord,
                                              update: update(propertyName: "historicRecord"),
                                              fail: singleQueryFailed),
            
            SingleItemQuery<RecommendInfos>(data: stockData.recommendInfos,
                                            update: update(propertyName: "recommendInfos"),
                                            fail: singleQueryFailed),
            
            SingleItemQuery<EarningInfos>(data: stockData.earningInfos,
                                          update: update(propertyName: "earningInfos"),
                                          fail: singleQueryFailed),
            
            SingleItemQuery<SocialSentimentList>(data: stockData.socialSentiments,
                                                 update: update(propertyName: "socialSentiments"),
                                                 fail: singleQueryFailed),
        ]
    }
    
    func update<T>(propertyName: String) -> (T) -> Void {
        return { value in
            self.stockData.updateProperty(name: propertyName, value: value as AnyObject)
        }
    }
    
    func singleQueryFailed() {
        self.status = .FAILED
    }
    
    func getUpdatedTime() -> TimeInterval {
        return self.currentTime
    }
    
    func startQuery(for stockTicker: String) {
        self.status = .PENDING
        super.startQuery(for: stockTicker, postQuery: postQuery)
    }
    
    func postQuery() {
        if status == .PENDING {
            status = .SUCCESS
        }
    }
}
