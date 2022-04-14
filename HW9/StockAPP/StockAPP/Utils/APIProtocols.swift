//
//  APIProtocols.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import Foundation

protocol APILinkable {
    func API_URL(stockTicker: String) -> URL?
}

extension APILinkable {
    func API_URL(stockTicker: String) -> URL? {
        nil
    }
}

extension Array: APILinkable {
    func API_URL(stockTicker: String) -> URL? {
        switch Element.self {
        case is SingleNews.Type: return URL(string: APILink + "news/\(stockTicker)")
        case is Peer.Type: return URL(string: APILink + "peers/\(stockTicker)")
        case is RecommendInfo.Type: return URL(string: APILink + "recommend/\(stockTicker)")
        case is EarningInfo.Type: return URL(string: APILink + "earnings/\(stockTicker)")
        default: return nil
        }
    }
}

protocol APIDebugable {
    func APIExample() -> Self
}

extension Array: APIDebugable {
    func APIExample() -> Self {
        switch Element.self {
        case is SingleNews.Type: return (newsExample() as! Array<Element>)
        case is Peer.Type: return (peersExample() as! Array<Element>)
        case is RecommendInfo.Type: return (RecommendInfoList() as! Array<Element>)
        case is EarningInfo.Type: return (EarningInfoList() as! Array<Element>)
        default: return []
        }
    }
}

protocol Updateable {
    mutating func update(new_data: Self)
}

extension Updateable {
    mutating func update(new_data: Self) {
        self = new_data
    }
}
