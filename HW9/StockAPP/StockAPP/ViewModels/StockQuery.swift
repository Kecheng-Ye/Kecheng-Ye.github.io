//
//  StockQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import Foundation

class StockQuery: GroupQuery {
    @Published var stockData = StockInfo()
    let semaphore = DispatchSemaphore(value: 0)
    var currentTime = NATime
    
    override init() {
        super.init()
        self.name = "StockQuery"
    }
    
    override func APIServicesInit() {
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
        super.startQuery(for: stockTicker)
    }
    
    func filterNews(rawNewsList: News) -> News {
        var count = 0
        var result = News()
        
        for singleNews in rawNewsList {
            
            if !singleNews.hasNilValue() {
                result.append(singleNews)
                count += 1
            }
            
            if count == NEWS_LIMIT {
                break
            }
        }
        
        return result
    }
}
