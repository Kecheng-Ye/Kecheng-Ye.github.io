//
//  utils.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation
import SwiftUI
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//
//  APIService.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation
//import Alamofire

// Reference from https://github.com/gahntpo/CatAPISwiftUI/blob/main/CatAPIProject/CatAPIProject/networking/APIService.swift
struct APIService {
    func fetch<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, APIError>) -> Void) {
        
        // check if the input URL is empty or not
        guard let url = url else {
            let error = APIError.emptyURL
            completion(Result.failure(error))
            return
        }
        
        // Define API Fetching Process
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            // Define each potential Error
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completion(Result.success(result))
                    
                } catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }

            }
        }
        
        // Start API Fetching
        task.resume()
    }
}

//
//  APIError.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case emptyURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
            case .emptyURL, .parsing, .unknown:
                return "Sorry, something went wrong."
            
            case .badResponse(_):
                return "Sorry, the connection to our server failed."
            
            case .url(let error):
                return error?.localizedDescription ?? "Something went wrong."
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
            case .unknown:
                return "unknown error"
            
            case .emptyURL:
                return "invalid URL"
            
            case .url(let error):
                return error?.localizedDescription ?? "url session error"
            
            case .parsing(let error):
                return "parsing error \(error?.localizedDescription ?? "")"
            
            case .badResponse(statusCode: let statusCode):
                return "bad response with status code \(statusCode)"
        }
    }
}


typealias Price = Float32
typealias Peer = String

let APILink = "http://kecheng-ye-hw8.us-east-1.elasticbeanstalk.com/api/"
let NAString = "N.A"
let NAInt: Int32 = 0
let NAFloat: Float32 = 0
let NATime: TimeInterval = 0
let NAPrice: Price = 0
let NAURL: URL? = nil

func timestampToString(_ datetime: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = SingleNews.dateFormat
    return dateFormatter.string(from: Date(timeIntervalSince1970: datetime))
}

struct stockColor: ViewModifier {
    let priceChange: Price
    
    func body(content: Content) -> some View {
        content.foregroundColor(
            priceChange > 0 ? .green :
                priceChange < 0 ? .red : .black
        )
    }
}

@ViewBuilder
func priceArrow(_ priceChange: Price) -> some View {
    if priceChange > 0 {
        Image(systemName: "arrow.up.right")
    } else if priceChange < 0 {
        Image(systemName: "arrow.down.left")
    }
}

extension View {
    func stockColorify(priceChange: Price) -> some View {
        self.modifier(stockColor(priceChange: priceChange))
    }
}

protocol PropertyLoopable {
    func allProperties() throws -> [String: Any]
}

extension PropertyLoopable {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            //throw some error
            throw NSError(domain: "hris.to", code: 777, userInfo: nil)
        }

        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }

            result[label] = valueMaybe
        }

        return result
    }
}

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
        case is SocialSentiment.Type: return URL(string: APILink + "social-sentiments/\(stockTicker)")
        default: return nil
        }
    }
}

protocol Serviceable {
    func startQuery(stockTicker: String, group: DispatchGroup)
}

protocol Dependable {
    associatedtype DependDataType
    var dependData: DependDataType { get set }
    
    mutating func updateDependData(data: DependDataType)
}

extension Dependable {
    mutating func updateDependData(data: DependDataType) {
        self.dependData = data
    }
}

public protocol ReflectedStringConvertible : CustomStringConvertible { }

extension ReflectedStringConvertible {
  public var description: String {
    let mirror = Mirror(reflecting: self)
    
    var str = "\(mirror.subjectType)("
    var first = true
    for (label, value) in mirror.children {
      if let label = label {
        if first {
          first = false
        } else {
          str += ", "
        }
        str += label
        str += ": "
        str += "\(value)"
      }
    }
    str += ")"
    
    return str
  }
}


//
//  CompanyBrief.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct CompanyBrief: Codable, APILinkable, ReflectedStringConvertible {
    let ipo: String
    let finnhubIndustry: String
    let name: String
    let ticker: String
    let weburl: URL?
    let logo: URL?
    
    init() {
        self.ipo = NAString
        self.finnhubIndustry = NAString
        self.name = NAString
        self.ticker = NAString
        self.weburl = NAURL
        self.logo = NAURL
    }
    
    init(ipo: String, finnhubIndustry: String, name: String, ticker: String, weburl: URL?, logo: URL?) {
        self.ipo = ipo
        self.finnhubIndustry = finnhubIndustry
        self.name = name
        self.ticker = ticker
        self.weburl = weburl
        self.logo = logo
    }
    
    static func example() -> CompanyBrief {
        CompanyBrief(
            ipo: "1980-12-12",
            finnhubIndustry: "Technology",
            name: "Apple Inc",
            ticker: "AAPL",
            weburl: URL(string: "https://www.apple.com/"),
            logo: URL(string: "https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png")
        )
        
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "brief/\(stockTicker)")
    }
}

//
//  CurrentPrice.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct CurrentPrice: Codable, APILinkable, ReflectedStringConvertible {
    let currentPrice: Price
    let priceChange: Price
    let priceChangePercent: Price
    let high: Price
    let low: Price
    let open: Price
    let previousClose: Price
    let timestamp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case priceChange = "d"
        case priceChangePercent = "dp"
        case high = "h"
        case low = "l"
        case open = "o"
        case previousClose = "pc"
        case timestamp = "t"
    }
    
    init(currentPrice: Price, priceChange: Price, priceChangePercent: Price,
         high: Price, low: Price,
         open: Price, previousClose: Price,
         timestamp: TimeInterval) {
        
        self.currentPrice = currentPrice
        self.priceChange = priceChange
        self.priceChangePercent = priceChangePercent
        self.high = high
        self.low = low
        self.open = open
        self.previousClose = previousClose
        self.timestamp = timestamp
    }
    
    init() {
        self.currentPrice = NAPrice
        self.priceChange = NAPrice
        self.priceChangePercent = NAPrice
        self.high = NAPrice
        self.low = NAPrice
        self.open = NAPrice
        self.previousClose = NAPrice
        self.timestamp = NATime
    }
    
    static func example1() -> CurrentPrice {
        CurrentPrice(
            currentPrice: 151.17,
            priceChange: -3.56,
            priceChangePercent: -2.3008,
            high: 154.12,
            low: 150.45,
            open: 151.45,
            previousClose: 154.73,
            timestamp: 1641647281134
        )
    }
    
    static func example2() -> CurrentPrice {
        CurrentPrice(
            currentPrice: 151.17,
            priceChange: 3.56,
            priceChangePercent: 2.3008,
            high: 154.12,
            low: 150.45,
            open: 151.45,
            previousClose: 154.73,
            timestamp: 1641647281134
        )
    }
    
    static func example3() -> CurrentPrice {
        CurrentPrice(
            currentPrice: 151.17,
            priceChange: 0,
            priceChangePercent: 0,
            high: 154.12,
            low: 150.45,
            open: 151.45,
            previousClose: 154.73,
            timestamp: 1641647281134
        )
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "price/\(stockTicker)")
    }
}


//
//  Peers.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

typealias Peers = [String]

func peersExample() -> Peers {
    [
      "AAPL",
      "DELL",
      "HPQ",
      "HPE",
      "1337.HK",
      "NTAP",
      "WDC",
      "PSTG",
      "XRX",
      "IONQ",
    ]
}

extension APILinkable where Self == Peers {
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "peers/\(stockTicker)")
    }
}


//
//  HourlyPrice.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct HourlyPrice: Codable, APILinkable, ReflectedStringConvertible, Dependable {
    typealias DependDataType = TimeInterval
    
    let closePrices: [Price]
    let timestamps: [TimeInterval]
    var dependData: DependDataType = NATime
    
    enum CodingKeys: String, CodingKey {
        case closePrices = "c"
        case timestamps = "t"
    }
    
    init() {
        closePrices = []
        timestamps = []
    }
    
    init(closePrices: [Price], timestamps: [TimeInterval]) {
        self.closePrices = closePrices
        self.timestamps = timestamps
    }
    
    static func example() -> HourlyPrice {
        HourlyPrice(
            closePrices:
                [
                152.1, 151.64, 151.71, 151.59, 151.74, 151.61, 151.9, 151.83, 152.13,
                152.36, 151.84, 151.8, 151.88, 151.43, 151.5, 151.53, 152.1, 152.01, 152.55,
                152.98, 152.72, 152.46, 152.34, 153.11, 153.615, 153.49, 153.44, 153.32,
                152.93, 152.88, 152.98, 153.16, 153.75, 153.98, 153.9153, 153.8867, 153.515,
                153.6401, 153.0299, 153.08, 153.01, 152.61, 152.3675, 152.2301, 152.53,
                152.485, 152.093, 151.58, 151.73, 152.0701, 152.005, 151.9698, 151.475,
                151.56, 151.8057, 151.62, 151.1299, 150.98, 150.645, 150.5152, 150.69,
                150.8701, 151.0001, 150.8003, 150.665, 150.7219, 150.92, 150.67, 151.27,
                151.0021, 151.04, 151.2462,
                ],
            timestamps:
                [
                1647259800, 1647260100, 1647260400, 1647260700, 1647261000, 1647261300,
                1647261600, 1647261900, 1647262200, 1647262500, 1647262800, 1647263100,
                1647263400, 1647263700, 1647264000, 1647264300, 1647264600, 1647264900,
                1647265200, 1647265500, 1647265800, 1647266100, 1647266400, 1647266700,
                1647267000, 1647267300, 1647267600, 1647267900, 1647268200, 1647268500,
                1647268800, 1647269100, 1647269400, 1647269700, 1647270000, 1647270300,
                1647270600, 1647270900, 1647271200, 1647271500, 1647271800, 1647272100,
                1647272400, 1647272700, 1647273000, 1647273300, 1647273600, 1647273900,
                1647274200, 1647274500, 1647274800, 1647275100, 1647275400, 1647275700,
                1647276000, 1647276300, 1647276600, 1647276900, 1647277200, 1647277500,
                1647277800, 1647278100, 1647278400, 1647278700, 1647279000, 1647279300,
                1647279600, 1647279900, 1647280200, 1647280500, 1647280800, 1647281100,
                ]
        )
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "hour-charts/\(stockTicker)" + "?start=\(Int(self.dependData))")
    }
}


//
//  News.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct SingleNews: Codable, Identifiable, ReflectedStringConvertible {
    let id: Int64
    let source: String
    let headline: String
    let summary: String
    let url: URL?
    let image: URL?
    let datetime: TimeInterval
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case datetime
        case headline
        case summary
        case url
        case image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int64.self, forKey: .id)
        source = try values.decode(String.self, forKey: .source)
        headline = try values.decode(String.self, forKey: .headline)
        summary = try values.decode(String.self, forKey: .summary)
        url = try? values.decode(URL.self, forKey: .url)
        image = try? values.decode(URL.self, forKey: .image)
        datetime = try values.decode(TimeInterval.self, forKey: .datetime)
        date = timestampToString(datetime)
    }

    init(id: Int64, source: String, headline: String, summary: String, url: URL?, image: URL?, datetime: TimeInterval){
        self.id = id
        self.source = source
        self.headline = headline
        self.summary = summary
        self.url = url
        self.image = image
        self.datetime = datetime
        self.date = timestampToString(datetime)
    }
    
    static let dateFormat = "MMM d, yyyy"
    
    static func example1() -> SingleNews {
        SingleNews(
            id: 109072509,
            source: "Yahoo",
            headline: "Dow Jones Futures: Market Rally Ailing, But These Stocks Are Healthy; Tesla Forges New Entry",
            summary: "The market rally is increasingly split. Tesla reversed lower, but has a handle. Callon leads stocks trading tightly.",
            url: URL(string: "https://finnhub.io/api/news?id=6fced1b8122e6f6b7e9bc9c252f425fd51c406e24779451e1d2a0b49ffb8207f"),
            image: nil,
            datetime: 1649611504.0
        )
    }
    
    static func example2() -> SingleNews {
        SingleNews(
            id: 109067745,
            source: "Yahoo",
            headline: "3 Powerful Stocks That Can Beat Inflation",
            summary: "These businesses have strong pricing power, which should make their stocks excellent hedges against inflation for investors.",
            url: URL(string: "https://finnhub.io/api/news?id=16cc393a20511af15dca85bd852b6216a13d06efc69786a49fd1d12a91b0a900"),
            image: URL(string: "https://s.yimg.com/ny/api/res/1.2/G1IfsIg27QjpiniXa7EizQ--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02NzU-/https://s.yimg.com/uu/api/res/1.2/PeUoVw9vH5ZgM4lQx8zJmA--~B/aD05MzQ7dz0xNDAwO2FwcGlkPXl0YWNoeW9u/https://media.zenfs.com/en/motleyfool.com/db1bc5c03441f5be744b4cbe00050097"),
            datetime: 1649588400.0
        )
    }
}

typealias News = [SingleNews]

//extension APILinkable where Self == News {
//    func API_URL(stockTicker: String) -> URL? {
//        return URL(string: APILink + "news/\(stockTicker)")
//    }
//}


//
//  HistoricalRecord.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct HistoricalRecord: Codable, APILinkable, ReflectedStringConvertible {
    let closePrices: [Price]
    let highPrices: [Price]
    let lowPrices: [Price]
    let openPrices: [Price]
    let timestamps: [TimeInterval]
    let volumes: [Int64]
    
    enum CodingKeys: String, CodingKey {
        case closePrices = "c"
        case highPrices = "h"
        case lowPrices = "l"
        case openPrices = "o"
        case volumes = "v"
        case timestamps = "t"
    }
    
    init() {
        closePrices = []
        highPrices = []
        lowPrices = []
        openPrices = []
        timestamps = []
        volumes = []
    }
    
    init(closePrices: [Price], highPrices: [Price], lowPrices: [Price],
         openPrices: [Price], timestamps: [TimeInterval], volumes: [Int64]) {
        self.closePrices = closePrices
        self.highPrices = highPrices
        self.lowPrices = lowPrices
        self.openPrices = openPrices
        self.timestamps = timestamps
        self.volumes = volumes
    }
    
    static func example() -> HistoricalRecord {
        HistoricalRecord(
            closePrices: [
                60.5525, 63.215, 61.6675, 61.195, 57.31, 56.0925, 61.72, 61.38, 64.61,
                61.935, 63.7025, 63.5725, 60.2275, 61.2325, 60.3525, 65.6175, 64.8575,
                66.5175, 66.9975, 68.3125, 71.7625, 71.1075, 71.6725, 70.7, 69.2325,
                67.0925, 69.025, 68.7575, 70.7425, 70.7925, 69.645, 71.9325, 73.45, 72.2675,
                73.29, 74.39, 75.1575, 75.935, 77.5325, 78.7525, 77.8525, 76.9125, 77.385,
                76.9275, 78.74, 78.285, 79.8075, 79.2125, 79.7225, 79.1825, 79.5275,
                79.5625, 79.485, 80.4625, 80.835, 81.28, 80.58, 82.875, 83.365, 85.9975,
                88.21, 83.975, 84.7, 85.7475, 88.02, 87.8975, 87.9325, 87.43, 89.7175,
                91.6325, 90.015, 91.21, 88.4075, 90.445, 91.2, 91.0275, 91.0275, 93.4625,
                93.1725, 95.3425, 95.6825, 95.92, 95.4775, 97.0575, 97.725, 96.5225,
                96.3275, 98.3575, 97, 97.2725, 92.845, 92.615, 94.81, 93.2525, 95.04, 96.19,
                106.26, 108.9375, 109.665, 110.0625, 113.9025, 111.1125, 112.7275, 109.375,
                113.01, 115.01, 114.9075, 114.6075, 115.5625, 115.7075, 118.275, 124.37,
                125.8575, 124.825, 126.5225, 125.01, 124.8075, 129.04, 134.18, 131.4,
                120.88, 120.96, 112.82, 117.32, 113.49, 112, 115.355, 115.54, 112.13,
                110.34, 106.84, 110.08, 111.81, 107.12, 108.22, 112.28, 114.96, 114.09,
                115.81, 116.79, 113.02, 116.5, 113.16, 115.08, 114.97, 116.97, 124.4, 121.1,
                121.19, 120.71, 119.02, 115.98, 117.51, 116.87, 115.75, 115.04, 115.05,
                116.6, 111.2, 115.32, 108.86, 108.77, 110.44, 114.95, 119.03, 118.69,
                116.32, 115.97, 119.49, 119.21, 119.26, 120.3, 119.39, 118.03, 118.64,
                117.34, 113.85, 115.17, 116.03, 116.59, 119.05, 122.72, 123.08, 122.94,
                122.25, 123.75, 124.38, 121.78, 123.24, 122.41, 121.78, 127.88, 127.81,
                128.7, 126.655, 128.23, 131.88, 130.96, 131.97, 136.69, 134.87, 133.72,
                132.69, 129.41, 131.01, 126.6, 130.92, 132.05, 128.98, 128.8, 130.89,
                128.91, 127.14, 127.83, 132.03, 136.87, 139.07, 142.92, 143.16, 142.06,
                137.09, 131.96, 134.14, 134.99, 133.94, 137.39, 136.76, 136.91, 136.01,
                135.39, 135.13, 135.37, 133.19, 130.84, 129.71, 129.87, 126, 125.86, 125.35,
                120.99, 121.26, 127.79, 125.12, 122.06, 120.13, 121.42, 116.36, 121.085,
                119.98, 121.96, 121.03, 123.99, 125.57, 124.76, 120.53, 119.99, 123.39,
                122.54, 120.09, 120.59, 121.21, 121.39, 119.9, 122.15, 123, 125.9, 126.21,
                127.9, 130.36, 132.995, 131.24, 134.43, 132.03, 134.5, 134.16, 134.84,
                133.11, 133.5, 131.94, 134.32, 134.72, 134.39, 133.58, 133.48, 131.46,
                132.54, 127.85, 128.1, 129.74, 130.21, 126.85, 125.91, 122.77, 124.97,
                127.45, 126.27, 124.85, 124.69, 127.31, 125.43, 127.1, 126.9, 126.85,
                125.28, 124.61, 124.28, 125.06, 123.54, 125.89, 125.9, 126.74, 127.13,
                126.11, 127.35, 130.48, 129.64, 130.15, 131.79, 130.46, 132.3, 133.98,
                133.7, 133.41, 133.11, 134.78, 136.33, 136.96, 137.27, 139.96, 142.02,
                144.57, 143.24, 145.11, 144.5, 145.64, 149.15, 148.48, 146.39, 142.45,
                146.15, 145.4, 146.8, 148.56, 148.99, 146.77, 144.98, 145.64, 145.86,
                145.52, 147.36, 146.95, 147.06, 146.14, 146.09, 145.6, 145.86, 148.89,
                149.1, 151.12, 150.19, 146.36, 146.7, 148.19, 149.71, 149.62, 148.36,
                147.54, 148.6, 153.12, 151.83, 152.51, 153.65, 154.3, 156.69, 155.11,
                154.07, 148.97, 149.55, 148.12, 149.03, 148.79, 146.06, 142.94, 143.43,
                145.85, 146.83, 146.92, 145.37, 141.91, 142.83, 141.5, 142.65, 139.14,
                141.11, 142, 143.29, 142.9, 142.81, 141.51, 140.91, 143.76, 144.84, 146.55,
                148.76, 149.26, 149.48, 148.69, 148.64, 149.32, 148.85, 152.57, 149.8,
                148.96, 150.02, 151.49, 150.96, 151.28, 150.44, 150.81, 147.92, 147.87,
                149.99, 150, 151, 153.49, 157.87, 160.55, 161.02, 161.41, 161.94, 156.81,
                160.24, 165.3, 164.77, 163.76, 161.84, 165.32, 171.18, 175.08, 174.56,
                179.45, 175.74, 174.33, 179.3, 172.26, 171.14, 169.75, 172.99, 175.64,
                176.28, 180.33, 179.29, 179.38, 178.2, 177.57, 182.01, 179.7, 174.92, 172,
                172.17, 172.19, 175.08, 175.53, 172.19, 173.07, 169.8, 166.23, 164.51,
                162.41, 161.62, 159.78, 159.69, 159.22, 170.33, 174.78, 174.61, 175.84,
                172.9, 172.39, 171.66, 174.83, 176.28, 172.12, 168.64, 168.88, 172.79,
                172.55, 168.88, 167.3, 164.32, 160.07, 162.74, 164.85, 165.12, 163.2,
                166.56, 166.23, 163.17, 159.3, 157.44, 162.95, 158.52, 154.73, 150.62,
                155.09,
              ],
            highPrices: [
                64.77, 64.4025, 62.5, 63.21, 62.9575, 57.124925, 61.9225, 64.5625, 64.67,
                63.9675, 63.88, 65.6225, 62.18, 61.2875, 61.425, 65.7775, 67.925, 66.8425,
                67.5175, 68.425, 72.0625, 71.5825, 72.049375, 71.73625, 70.42, 69.3125,
                69.475, 70.4375, 70.7525, 71.135, 71.4575, 72.4175, 73.6325, 74.75, 73.4225,
                75.25, 75.81, 76.2925, 77.5875, 79.2625, 79.922, 78.9875, 77.4475, 76.975,
                79.125, 79.63, 79.88, 80.2225, 79.8075, 81.06, 79.6775, 80.86, 80.2875,
                80.5875, 80.86, 81.55, 81.405, 82.9375, 83.4, 86.4025, 88.6925, 87.765,
                86.95, 86.42, 88.3, 88.85, 88.3625, 89.14, 89.865, 93.095, 92.1975, 91.25,
                91.33, 90.5434, 91.495, 91.84, 92.6175, 93.945, 94.655, 95.375, 96.3175,
                95.98, 99.955, 97.255, 99.2475, 97.405, 97.1475, 98.5, 99.25, 97.975,
                97.0775, 92.97, 94.905, 94.54965, 95.23, 96.2975, 106.415, 111.636425,
                110.79, 110.3925, 114.4125, 113.675, 113.775, 112.4825, 113.275, 116.0425,
                115, 116.0875, 116, 117.1625, 118.392, 124.868, 128.785, 125.1793, 126.9925,
                127.485, 126.4425, 131, 134.8, 137.98, 128.84, 123.7, 118.99, 119.14, 120.5,
                115.23, 115.93, 118.829, 116, 112.2, 110.88, 110.19, 112.86, 112.11, 110.25,
                112.44, 115.32, 115.31, 117.26, 117.72, 115.37, 116.65, 116.12, 115.55,
                116.4, 117, 125.18, 125.39, 123.03, 121.2, 121.548, 120.419, 118.98,
                118.705, 118.04, 116.55, 116.55, 117.28, 115.43, 116.93, 111.99, 110.68,
                111.49, 115.59, 119.62, 119.2, 121.99, 117.59, 119.63, 120.53, 119.6717,
                120.99, 120.6741, 119.82, 119.06, 118.77, 117.6202, 115.85, 116.75, 117.49,
                120.97, 123.4693, 123.37, 123.78, 122.8608, 124.57, 124.98, 125.95, 123.87,
                122.76, 123.35, 127.9, 128.37, 129.58, 129.1, 128.31, 134.405, 132.43,
                133.46, 137.34, 138.789, 135.99, 134.74, 133.6116, 131.74, 131.0499, 131.63,
                132.63, 130.17, 129.69, 131.45, 131, 130.2242, 128.71, 132.49, 139.67,
                139.85, 145.09, 144.3, 144.3, 141.99, 136.74, 135.38, 136.31, 135.77, 137.4,
                137.42, 136.96, 137.877, 136.99, 136.39, 135.53, 136.01, 132.22, 129.995,
                130.71, 129.72, 126.71, 125.56, 126.4585, 124.85, 127.93, 128.72, 125.71,
                123.6, 121.935, 121, 122.06, 122.17, 123.21, 121.17, 124, 127.22, 125.8599,
                123.18, 121.43, 123.87, 124.24, 122.9, 121.66, 121.48, 122.58, 120.4031,
                123.52, 124.18, 126.1601, 127.13, 127.92, 130.39, 133.04, 132.85, 134.66,
                135, 135, 134.67, 135.47, 135.53, 133.75, 134.15, 135.12, 135.06, 135.41,
                135.02, 137.07, 133.56, 134.07, 131.4899, 130.45, 129.75, 131.2582, 129.54,
                126.27, 124.64, 126.15, 127.89, 126.93, 126.99, 124.915, 127.72, 128,
                127.94, 128.32, 127.39, 127.64, 125.8, 125.35, 125.24, 124.85, 126.16,
                126.32, 128.46, 127.75, 128.19, 127.44, 130.54, 130.6, 130.89, 132.55,
                131.51, 132.41, 134.08, 134.32, 134.64, 133.89, 135.245, 136.49, 137.41,
                137.33, 140, 143.15, 144.89, 144.06, 145.65, 146.32, 147.46, 149.57, 150,
                149.76, 144.07, 147.0997, 146.13, 148.195, 148.7177, 149.83, 149.21, 146.97,
                146.55, 146.33, 146.95, 148.045, 147.79, 147.84, 147.11, 146.7, 147.71,
                146.72, 149.05, 149.4444, 151.19, 151.68, 150.72, 148, 148.5, 150.19,
                150.86, 150.32, 149.12, 148.75, 153.49, 152.8, 154.98, 154.72, 154.63,
                157.26, 157.04, 156.11, 155.48, 151.42, 151.07, 149.44, 148.97, 148.82,
                144.84, 144.6, 146.43, 147.08, 147.4701, 145.96, 144.75, 144.45, 144.378,
                142.92, 142.21, 142.24, 142.15, 144.215, 144.1781, 144.81, 143.25, 141.4,
                143.88, 144.895, 146.84, 149.17, 149.7539, 149.64, 150.18, 149.37, 150.84,
                149.73, 153.165, 149.94, 149.7, 151.57, 151.97, 152.43, 152.2, 151.57,
                151.428, 150.13, 149.43, 150.4, 151.88, 151.488, 155, 158.67, 161.02, 165.7,
                161.8, 162.14, 160.45, 161.19, 165.52, 170.3, 164.2, 164.96, 167.8799,
                171.58, 175.96, 176.75, 179.63, 182.13, 177.74, 179.5, 181.14, 173.47,
                170.58, 173.2, 175.86, 176.8499, 180.42, 181.33, 180.63, 180.57, 179.23,
                182.88, 182.94, 180.17, 175.3, 174.14, 172.5, 175.18, 177.18, 176.62,
                173.78, 172.54, 171.08, 169.68, 166.33, 162.3, 162.76, 164.3894, 163.84,
                170.35, 175, 174.84, 175.88, 176.2399, 174.1, 173.9458, 175.35, 176.65,
                175.48, 173.08, 169.58, 172.95, 173.34, 171.91, 170.5413, 166.69, 166.15,
                162.85, 165.12, 165.42, 166.6, 167.36, 168.91, 165.55, 165.02, 162.88,
                163.41, 160.39, 159.28, 154.12, 155.57,
              ],
            lowPrices: [
                60, 59.6, 59.28, 60.6525, 57, 53.1525, 58.575, 61.075, 61.59, 61.7625,
                62.35, 63, 59.7825, 59.225, 59.743525, 62.345, 64.75, 65.3075, 66.175,
                66.4575, 69.5125, 70.1575, 70.58755, 69.215, 69.2125, 66.3575, 68.05,
                68.7175, 69.25, 69.9875, 69.55, 70.9725, 72.0875, 71.4625, 71.5793, 73.615,
                74.7175, 75.4925, 76.0725, 76.81, 77.7275, 75.8025, 75.3825, 75.0525,
                77.581025, 78.2525, 79.05, 78.9675, 78.8375, 79.125, 78.2725, 78.9075,
                79.1175, 79.3025, 79.7325, 80.575, 80.195, 80.8075, 81.83, 83.0025, 86.5225,
                83.87, 83.555825, 83.145, 86.18, 87.7725, 87.305, 86.2875, 87.7875,
                90.567525, 89.63, 89.3925, 88.255, 87.82, 90, 90.9775, 90.91, 92.4675,
                93.0575, 94.09, 94.6725, 94.705175, 95.2575, 93.8775, 96.49, 95.905, 95.84,
                96.0625, 96.7425, 96.6025, 92.00975, 89.145, 93.48, 93.2475, 93.7125,
                93.7675, 100.825, 107.8925, 108.3875, 108.8975, 109.7975, 110.2925, 110,
                109.106675, 110.2975, 113.9275, 113.045, 113.962525, 114.0075, 115.61,
                115.733375, 119.25, 123.93625, 123.0525, 125.0825, 123.8325, 124.5775, 126,
                130.53, 127, 120.5, 110.89, 112.68, 115.26, 112.5, 110, 112.8, 113.61,
                112.04, 108.71, 106.09, 103.1, 109.16, 106.77, 105, 107.67, 112.78, 113.57,
                113.62, 115.83, 112.22, 113.55, 112.25, 114.13, 114.5901, 114.92, 119.2845,
                119.65, 119.62, 118.15, 118.81, 115.66, 115.63, 116.45, 114.59, 114.28,
                112.88, 114.5399, 111.1, 112.2, 107.72, 107.32, 108.73, 112.35, 116.8686,
                116.13, 116.05, 114.13, 116.44, 118.57, 117.87, 118.146, 118.96, 118,
                116.81, 117.29, 113.75, 112.59, 115.17, 116.22, 116.81, 120.01, 120.89,
                122.21, 121.52, 122.25, 123.09, 121, 120.15, 120.55, 121.54, 124.13, 126.56,
                128.045, 126.12, 123.449, 129.65, 130.78, 131.1, 133.51, 134.3409, 133.4,
                131.72, 126.76, 128.43, 126.382, 127.86, 130.23, 128.5, 126.86, 128.49,
                128.76, 127, 126.938, 128.55, 133.59, 135.02, 136.54, 141.37, 140.41, 136.7,
                130.21, 130.93, 134.61, 133.61, 134.59, 135.86, 134.92, 135.85, 134.4,
                133.77, 133.6921, 132.79, 129.47, 127.41, 128.8, 125.6, 118.39, 122.23,
                120.54, 121.2, 122.79, 125.01, 121.84, 118.62, 117.57, 116.21, 118.79,
                119.45, 121.26, 119.16, 120.42, 124.715, 122.336, 120.32, 119.675, 120.26,
                122.14, 120.065, 119, 118.92, 120.7299, 118.86, 121.15, 122.49, 123.07,
                125.65, 125.14, 128.52, 129.47, 130.63, 131.93, 131.655, 133.64, 133.28,
                133.34, 131.81, 131.3001, 131.41, 132.16, 133.56, 134.11, 133.08, 132.45,
                131.065, 131.83, 126.7, 127.97, 127.13, 129.475, 126.81, 122.77, 122.25,
                124.26, 125.85, 125.17, 124.78, 122.86, 125.1, 125.21, 125.94, 126.32,
                126.42, 125.08, 124.55, 123.94, 124.05, 123.13, 123.85, 124.8321, 126.2101,
                126.52, 125.94, 126.1, 127.07, 129.39, 128.461, 129.65, 130.24, 129.21,
                131.62, 133.23, 132.93, 132.81, 133.35, 134.35, 135.87, 135.76, 137.745,
                140.07, 142.66, 140.665, 142.6522, 144, 143.63, 147.68, 147.09, 145.88,
                141.67, 142.96, 144.63, 145.81, 146.92, 147.7, 145.55, 142.54, 144.58,
                144.11, 145.25, 145.18, 146.28, 146.17, 145.63, 145.52, 145.3, 145.53,
                145.84, 148.27, 146.47, 149.09, 146.15, 144.5, 146.78, 147.89, 149.15,
                147.8, 147.51, 146.83, 148.61, 151.29, 152.34, 152.4, 153.09, 154.39,
                153.975, 153.95, 148.7, 148.75, 146.91, 146.37, 147.221, 145.76, 141.27,
                142.78, 143.7001, 145.64, 145.56, 143.82, 141.69, 142.03, 141.28, 139.1101,
                138.27, 139.36, 138.37, 142.72, 142.56, 141.81, 141.0401, 139.2, 141.51,
                143.51, 143.16, 146.55, 148.12, 147.87, 148.64, 147.6211, 149.0101, 148.49,
                149.72, 146.4128, 147.8, 148.65, 149.82, 150.64, 150.06, 150.16, 150.0601,
                147.85, 147.681, 147.48, 149.43, 149.34, 150.99, 153.05, 156.5328, 161,
                159.0601, 159.64, 156.36, 158.7901, 159.92, 164.53, 157.8, 159.72, 164.28,
                168.34, 170.7, 173.92, 174.69, 175.53, 172.21, 172.3108, 170.75, 169.69,
                167.46, 169.12, 172.15, 175.27, 177.07, 178.53, 178.14, 178.09, 177.26,
                177.71, 179.12, 174.64, 171.64, 171.03, 168.17, 170.82, 174.82, 171.79,
                171.09, 169.405, 165.94, 164.18, 162.3, 154.7, 157.02, 157.82, 158.28,
                162.8, 169.51, 172.31, 173.33, 172.12, 170.68, 170.95, 171.43, 174.9,
                171.55, 168.04, 166.56, 170.25, 170.05, 168.47, 166.19, 162.15, 159.75, 152,
                160.8738, 162.43, 161.97, 162.95, 165.55, 162.1, 159.04, 155.8, 159.41,
                155.98, 154.5, 150.1, 150.385,
              ],
            openPrices: [
                60.4875, 61.8775, 59.9425, 61.84625, 61.795, 57.02, 59.09, 62.6875, 61.63,
                63.1875, 62.685, 63.9, 61.625, 60.085, 60.7, 62.725, 67.7, 65.685, 67.175,
                67.0775, 70, 70.6, 71.845, 71.1725, 69.4875, 69.07, 68.4025, 68.9675, 69.3,
                70.45, 71.27, 71.1825, 72.49, 71.5625, 72.2925, 73.765, 75.115, 75.805,
                76.41, 77.025, 79.4575, 78.0375, 76.1275, 75.0875, 78.2925, 78.7575, 79.17,
                79.665, 78.9425, 80.875, 79.035, 79.1925, 79.8125, 79.4375, 80.18625,
                81.165, 81.0975, 80.8375, 82.5625, 83.035, 86.975, 87.3275, 86.18, 83.3125,
                87.865, 88.7875, 87.8525, 88.65875, 87.835, 91, 91.25, 90.175, 91.1025,
                88.3125, 90.02, 91.28, 91.9625, 92.5, 93.8525, 94.18, 96.2625, 95.335,
                97.265, 94.84, 98.99, 96.5625, 96.9875, 96.41625, 99.1725, 96.6925,
                96.998375, 90.9875, 93.71, 94.3675, 93.75, 94.1875, 102.88375, 108.2,
                109.1325, 109.3775, 110.405, 113.205, 112.6, 111.96875, 110.4975, 114.43,
                114.82875, 116.0625, 114.3525, 115.98325, 115.75, 119.2625, 128.6975,
                124.6975, 126.179125, 127.1425, 126.0125, 127.58, 132.76, 137.59, 126.91,
                120.07, 113.95, 117.26, 120.36, 114.57, 114.72, 118.33, 115.23, 109.72,
                110.4, 104.54, 112.68, 111.62, 105.17, 108.43, 115.01, 114.55, 113.79,
                117.64, 112.89, 113.91, 115.7, 114.62, 116.25, 115.28, 120.06, 125.27, 121,
                118.72, 121.28, 119.96, 116.2, 116.67, 117.45, 116.39, 114.01, 115.49,
                115.05, 112.37, 111.06, 109.11, 109.66, 114.14, 117.95, 118.32, 120.5,
                115.55, 117.19, 119.62, 119.44, 118.92, 119.55, 118.61, 117.59, 118.64,
                117.18, 113.91, 115.55, 116.57, 116.97, 121.01, 122.02, 123.52, 122.6,
                122.31, 124.37, 124.53, 120.5, 122.43, 122.6, 124.34, 127.41, 128.9, 128.96,
                125.02, 131.61, 132.16, 131.32, 133.99, 138.05, 135.58, 134.08, 133.52,
                128.89, 127.72, 128.36, 132.43, 129.19, 128.5, 128.76, 130.8, 128.78,
                127.78, 128.66, 133.8, 136.28, 143.07, 143.6, 143.43, 139.52, 135.83,
                133.75, 135.73, 135.76, 136.3, 137.35, 136.03, 136.62, 136.48, 135.9,
                134.35, 135.49, 131.25, 129.2, 130.24, 128.01, 123.76, 124.94, 124.68,
                122.59, 123.75, 128.41, 124.81, 121.75, 120.98, 120.93, 119.03, 121.69,
                122.54, 120.4, 121.41, 125.7, 124.05, 122.88, 119.9, 120.33, 123.33, 122.82,
                119.54, 120.35, 121.65, 120.11, 121.65, 123.66, 123.87, 126.5, 125.83,
                128.95, 129.8, 132.52, 132.44, 134.94, 133.82, 134.3, 133.51, 135.02,
                132.36, 133.04, 132.16, 134.83, 135.01, 134.31, 136.47, 131.78, 132.04,
                131.19, 129.2, 127.89, 130.85, 129.41, 123.5, 123.4, 124.58, 126.25, 126.82,
                126.56, 123.16, 125.23, 127.82, 126.01, 127.82, 126.955, 126.44, 125.57,
                125.08, 124.28, 124.68, 124.07, 126.17, 126.6, 127.21, 127.02, 126.53,
                127.82, 129.94, 130.37, 129.8, 130.71, 130.3, 132.13, 133.77, 134.45,
                133.46, 133.41, 134.8, 136.17, 136.6, 137.9, 140.07, 143.535, 141.58,
                142.75, 146.21, 144.03, 148.1, 149.24, 148.46, 143.75, 143.46, 145.53,
                145.935, 147.55, 148.27, 149.12, 144.81, 144.685, 144.38, 146.36, 145.81,
                147.27, 146.98, 146.35, 146.2, 146.44, 146.05, 146.19, 148.97, 148.535,
                150.23, 149.8, 145.03, 147.44, 148.31, 149.45, 149.81, 148.35, 147.48, 149,
                152.66, 152.83, 153.87, 153.76, 154.97, 156.98, 155.49, 155, 150.63, 150.35,
                148.56, 148.44, 148.82, 143.8, 143.93, 144.45, 146.65, 145.66, 145.47,
                143.25, 142.47, 143.66, 141.9, 141.76, 139.49, 139.47, 143.06, 144.03,
                142.27, 143.23, 141.235, 142.11, 143.77, 143.445, 147.01, 148.7, 148.81,
                149.69, 148.68, 149.33, 149.36, 149.82, 147.215, 148.985, 148.66, 150.39,
                151.58, 151.89, 151.41, 150.2, 150.02, 148.96, 148.43, 150.37, 149.94,
                150.995, 153.71, 157.65, 161.68, 161.12, 160.75, 159.565, 159.37, 159.985,
                167.48, 158.735, 164.02, 164.29, 169.08, 172.125, 174.91, 175.205, 181.115,
                175.25, 175.11, 179.28, 169.93, 168.28, 171.555, 173.04, 175.85, 177.085,
                180.16, 179.33, 179.47, 178.085, 177.83, 182.63, 179.61, 172.7, 172.89,
                169.08, 172.32, 176.12, 175.78, 171.34, 171.51, 170, 166.98, 164.415,
                160.02, 158.98, 163.5, 162.45, 165.71, 170.16, 174.01, 174.745, 174.48,
                171.68, 172.86, 171.73, 176.05, 174.14, 172.33, 167.37, 170.97, 171.85,
                171.03, 169.82, 164.98, 165.54, 152.58, 163.84, 163.06, 164.695, 164.39,
                168.47, 164.49, 163.36, 158.82, 161.475, 160.2, 158.93, 151.45, 150.9,
              ],
            timestamps: [
                1584316800, 1584403200, 1584489600, 1584576000, 1584662400, 1584921600,
                1585008000, 1585094400, 1585180800, 1585267200, 1585526400, 1585612800,
                1585699200, 1585785600, 1585872000, 1586131200, 1586217600, 1586304000,
                1586390400, 1586736000, 1586822400, 1586908800, 1586995200, 1587081600,
                1587340800, 1587427200, 1587513600, 1587600000, 1587686400, 1587945600,
                1588032000, 1588118400, 1588204800, 1588291200, 1588550400, 1588636800,
                1588723200, 1588809600, 1588896000, 1589155200, 1589241600, 1589328000,
                1589414400, 1589500800, 1589760000, 1589846400, 1589932800, 1590019200,
                1590105600, 1590451200, 1590537600, 1590624000, 1590710400, 1590969600,
                1591056000, 1591142400, 1591228800, 1591315200, 1591574400, 1591660800,
                1591747200, 1591833600, 1591920000, 1592179200, 1592265600, 1592352000,
                1592438400, 1592524800, 1592784000, 1592870400, 1592956800, 1593043200,
                1593129600, 1593388800, 1593475200, 1593561600, 1593648000, 1593993600,
                1594080000, 1594166400, 1594252800, 1594339200, 1594598400, 1594684800,
                1594771200, 1594857600, 1594944000, 1595203200, 1595289600, 1595376000,
                1595462400, 1595548800, 1595808000, 1595894400, 1595980800, 1596067200,
                1596153600, 1596412800, 1596499200, 1596585600, 1596672000, 1596758400,
                1597017600, 1597104000, 1597190400, 1597276800, 1597363200, 1597622400,
                1597708800, 1597795200, 1597881600, 1597968000, 1598227200, 1598313600,
                1598400000, 1598486400, 1598572800, 1598832000, 1598918400, 1599004800,
                1599091200, 1599177600, 1599523200, 1599609600, 1599696000, 1599782400,
                1600041600, 1600128000, 1600214400, 1600300800, 1600387200, 1600646400,
                1600732800, 1600819200, 1600905600, 1600992000, 1601251200, 1601337600,
                1601424000, 1601510400, 1601596800, 1601856000, 1601942400, 1602028800,
                1602115200, 1602201600, 1602460800, 1602547200, 1602633600, 1602720000,
                1602806400, 1603065600, 1603152000, 1603238400, 1603324800, 1603411200,
                1603670400, 1603756800, 1603843200, 1603929600, 1604016000, 1604275200,
                1604361600, 1604448000, 1604534400, 1604620800, 1604880000, 1604966400,
                1605052800, 1605139200, 1605225600, 1605484800, 1605571200, 1605657600,
                1605744000, 1605830400, 1606089600, 1606176000, 1606262400, 1606435200,
                1606694400, 1606780800, 1606867200, 1606953600, 1607040000, 1607299200,
                1607385600, 1607472000, 1607558400, 1607644800, 1607904000, 1607990400,
                1608076800, 1608163200, 1608249600, 1608508800, 1608595200, 1608681600,
                1608768000, 1609113600, 1609200000, 1609286400, 1609372800, 1609718400,
                1609804800, 1609891200, 1609977600, 1610064000, 1610323200, 1610409600,
                1610496000, 1610582400, 1610668800, 1611014400, 1611100800, 1611187200,
                1611273600, 1611532800, 1611619200, 1611705600, 1611792000, 1611878400,
                1612137600, 1612224000, 1612310400, 1612396800, 1612483200, 1612742400,
                1612828800, 1612915200, 1613001600, 1613088000, 1613433600, 1613520000,
                1613606400, 1613692800, 1613952000, 1614038400, 1614124800, 1614211200,
                1614297600, 1614556800, 1614643200, 1614729600, 1614816000, 1614902400,
                1615161600, 1615248000, 1615334400, 1615420800, 1615507200, 1615766400,
                1615852800, 1615939200, 1616025600, 1616112000, 1616371200, 1616457600,
                1616544000, 1616630400, 1616716800, 1616976000, 1617062400, 1617148800,
                1617235200, 1617580800, 1617667200, 1617753600, 1617840000, 1617926400,
                1618185600, 1618272000, 1618358400, 1618444800, 1618531200, 1618790400,
                1618876800, 1618963200, 1619049600, 1619136000, 1619395200, 1619481600,
                1619568000, 1619654400, 1619740800, 1620000000, 1620086400, 1620172800,
                1620259200, 1620345600, 1620604800, 1620691200, 1620777600, 1620864000,
                1620950400, 1621209600, 1621296000, 1621382400, 1621468800, 1621555200,
                1621814400, 1621900800, 1621987200, 1622073600, 1622160000, 1622505600,
                1622592000, 1622678400, 1622764800, 1623024000, 1623110400, 1623196800,
                1623283200, 1623369600, 1623628800, 1623715200, 1623801600, 1623888000,
                1623974400, 1624233600, 1624320000, 1624406400, 1624492800, 1624579200,
                1624838400, 1624924800, 1625011200, 1625097600, 1625184000, 1625529600,
                1625616000, 1625702400, 1625788800, 1626048000, 1626134400, 1626220800,
                1626307200, 1626393600, 1626652800, 1626739200, 1626825600, 1626912000,
                1626998400, 1627257600, 1627344000, 1627430400, 1627516800, 1627603200,
                1627862400, 1627948800, 1628035200, 1628121600, 1628208000, 1628467200,
                1628553600, 1628640000, 1628726400, 1628812800, 1629072000, 1629158400,
                1629244800, 1629331200, 1629417600, 1629676800, 1629763200, 1629849600,
                1629936000, 1630022400, 1630281600, 1630368000, 1630454400, 1630540800,
                1630627200, 1630972800, 1631059200, 1631145600, 1631232000, 1631491200,
                1631577600, 1631664000, 1631750400, 1631836800, 1632096000, 1632182400,
                1632268800, 1632355200, 1632441600, 1632700800, 1632787200, 1632873600,
                1632960000, 1633046400, 1633305600, 1633392000, 1633478400, 1633564800,
                1633651200, 1633910400, 1633996800, 1634083200, 1634169600, 1634256000,
                1634515200, 1634601600, 1634688000, 1634774400, 1634860800, 1635120000,
                1635206400, 1635292800, 1635379200, 1635465600, 1635724800, 1635811200,
                1635897600, 1635984000, 1636070400, 1636329600, 1636416000, 1636502400,
                1636588800, 1636675200, 1636934400, 1637020800, 1637107200, 1637193600,
                1637280000, 1637539200, 1637625600, 1637712000, 1637884800, 1638144000,
                1638230400, 1638316800, 1638403200, 1638489600, 1638748800, 1638835200,
                1638921600, 1639008000, 1639094400, 1639353600, 1639440000, 1639526400,
                1639612800, 1639699200, 1639958400, 1640044800, 1640131200, 1640217600,
                1640563200, 1640649600, 1640736000, 1640822400, 1640908800, 1641168000,
                1641254400, 1641340800, 1641427200, 1641513600, 1641772800, 1641859200,
                1641945600, 1642032000, 1642118400, 1642464000, 1642550400, 1642636800,
                1642723200, 1642982400, 1643068800, 1643155200, 1643241600, 1643328000,
                1643587200, 1643673600, 1643760000, 1643846400, 1643932800, 1644192000,
                1644278400, 1644364800, 1644451200, 1644537600, 1644796800, 1644883200,
                1644969600, 1645056000, 1645142400, 1645488000, 1645574400, 1645660800,
                1645747200, 1646006400, 1646092800, 1646179200, 1646265600, 1646352000,
                1646611200, 1646697600, 1646784000, 1646870400, 1646956800, 1647216000,
                1647302400,
              ],
            volumes: [
                322423460, 324055860, 300233624, 271857020, 401693384, 336752832, 287531092,
                303602040, 252560676, 204216612, 167976440, 197002004, 176218552, 165933972,
                129880068, 201820284, 202887324, 168895284, 162116492, 131022924, 194994688,
                131154564, 157125160, 215249912, 130015000, 180991572, 117057368, 124814328,
                126508732, 117087572, 112004748, 137280816, 183063872, 240616700, 133567944,
                147751180, 142333752, 115215056, 134047940, 145946244, 162301052, 200622556,
                158929076, 166348376, 135372500, 101729540, 111504860, 102688844, 81803016,
                125521816, 112945096, 133796412, 153598128, 81018612, 87642816, 104491216,
                87560364, 137250200, 95654536, 147712364, 166651752, 201662452, 200146052,
                138808920, 165428728, 114406504, 96820384, 264475808, 135445264, 212155476,
                192623396, 137522512, 205256844, 130646076, 140223284, 110737236, 114041468,
                118655652, 112424456, 117091880, 125642608, 90257320, 191649140, 170989364,
                153197932, 110577672, 92186900, 90317908, 103645836, 89001652, 197004432,
                185438864, 121214192, 103625500, 90329256, 158130020, 374295468, 308151388,
                172792368, 121991952, 202428900, 198045612, 212403424, 187902376, 165944820,
                210082064, 165565208, 119561444, 105633540, 145538008, 126907188, 338054640,
                345937768, 211495788, 163022268, 155552384, 187629916, 225702688, 152470142,
                200118991, 257599640, 332607163, 231366563, 176940455, 182274391, 180860325,
                140150087, 184642039, 155026675, 178010968, 287104882, 195713815, 183055373,
                150718671, 167743349, 149981441, 137672403, 100060526, 142675184, 116120440,
                144711986, 106243839, 161498212, 96848985, 83477153, 100506865, 240226769,
                262330451, 151062308, 112559219, 115393808, 120639337, 124423728, 89945980,
                101987954, 82572645, 111850657, 92276772, 143937823, 146129173, 190573476,
                122866899, 107624448, 138235482, 126387074, 114457922, 154515315, 138023390,
                112294954, 103350674, 81688586, 91183018, 74270973, 76322111, 74112972,
                73604287, 127959318, 113874218, 76499234, 46691331, 169410176, 128166803,
                89004195, 78967630, 78260421, 86711990, 82225512, 115089193, 81312170,
                86939786, 79075988, 157572262, 98208591, 94359811, 192541496, 121251553,
                169351825, 88223692, 54930064, 124486237, 121047324, 96452124, 99116586,
                143301887, 97664898, 155087970, 109578157, 105158245, 100620880, 91951145,
                88636831, 90221755, 111598531, 90757329, 104319489, 120529544, 114459360,
                157611713, 98390555, 140843759, 142621128, 177523812, 106239823, 83305367,
                89880937, 84183061, 75693830, 71297214, 76774213, 73046563, 64280029,
                60145130, 80576316, 98085249, 96856748, 87668834, 103916419, 158273022,
                111039904, 148199540, 164560394, 116307892, 102260945, 112966340, 178154975,
                153766601, 154376610, 129525780, 111943326, 103026514, 88105050, 92590555,
                115227936, 111932636, 121469755, 185549522, 111912284, 95467142, 88530485,
                98844681, 94071234, 80819203, 85671919, 118323826, 75089134, 88651175,
                80171253, 83466716, 88844591, 106686703, 91419983, 91266545, 87222782,
                89347102, 84922386, 94264215, 94812349, 68847136, 84566456, 78756779,
                66905069, 66015804, 107760097, 151100953, 109839466, 75135100, 137564718,
                84000900, 78128334, 78973273, 88071229, 126142826, 112172282, 105861339,
                81917951, 74244624, 63342929, 92611989, 76857123, 79295436, 63092945,
                72009482, 56575920, 94625601, 71311109, 67637118, 59278862, 76229170,
                75169343, 71057550, 74403774, 56877937, 71186421, 53522373, 96906490,
                62746332, 91815026, 96721669, 108953309, 79663316, 74783618, 60214200,
                68710998, 70783746, 62111303, 64556081, 63261393, 52485781, 78945572,
                108181793, 104911589, 105575458, 99890800, 76299719, 100827099, 127050785,
                106820297, 93251426, 121434571, 96350036, 74993460, 77338156, 71447416,
                72434089, 104818578, 118931191, 56699475, 70440626, 62879961, 64786618,
                56368271, 46397674, 54126813, 48908689, 69023081, 48493463, 73779113,
                59375009, 103558782, 92229735, 86325990, 86960310, 60549630, 60131810,
                48606428, 58991297, 48597195, 55802388, 90956723, 86453117, 80313711,
                71171317, 57866066, 82278261, 74420207, 57305730, 140893235, 102404329,
                109296295, 83281315, 68034149, 129868824, 123478863, 75833962, 76404341,
                64838170, 53477869, 74150729, 108972340, 74602044, 89056664, 94639581,
                98322008, 80861062, 83221119, 61732656, 58773155, 64452219, 73035859,
                78762721, 69907100, 67940334, 85589175, 76378894, 58418788, 61420990,
                58883443, 50720556, 60893395, 56094929, 100077888, 124953168, 74588258,
                69121987, 54511534, 60394616, 65463883, 55020868, 56787930, 65187092,
                40999950, 63804008, 59222803, 59256210, 88807000, 137827673, 117305597,
                117467889, 96041899, 69463623, 76959752, 88748217, 174048056, 152423003,
                136739174, 118023116, 107496982, 120405352, 116998901, 108923739, 115402731,
                153237019, 139380382, 131063257, 150185843, 195923441, 107499114, 91185905,
                92135303, 68356567, 74919582, 79144339, 62348931, 59773014, 64062261,
                104701220, 99310438, 94537602, 96903955, 86709147, 106765552, 76138312,
                74805173, 84505760, 80440780, 91168729, 94814990, 91420515, 122848858,
                162706686, 115798367, 108275308, 121954638, 179935660, 115541590, 86213911,
                84914256, 89418074, 82465400, 77251204, 74829217, 71285038, 90865899,
                98670687, 86185530, 64286320, 61177398, 69589344, 82772674, 91162758,
                90009247, 141147540, 91974222, 95056629, 83474425, 79724750, 76678441,
                83819592, 96418845, 131148280, 91454905, 105342033, 96970102, 108732111,
                89231766,
          ]
        )
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "historical-charts/\(stockTicker)" + "?start=\(Int(Date().timeIntervalSince1970))")
    }
}


//
//  RecommendInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct RecommendInfo: Codable, ReflectedStringConvertible {
    let buy: Int32
    let hold: Int32
    let period: String
    let sell: Int32
    let strongBuy: Int32
    let strongSell: Int32
    let symbol: String
    
    static func example1() -> RecommendInfo {
        RecommendInfo(
            buy: 26,
            hold: 8,
            period: "2022-04-01",
            sell: 0,
            strongBuy: 18,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
    
    static func example2() -> RecommendInfo {
        RecommendInfo(
            buy: 26,
            hold: 8,
            period: "2022-03-01",
            sell: 0,
            strongBuy: 18,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
    
    static func example3() -> RecommendInfo {
        RecommendInfo(
            buy: 26,
            hold: 8,
            period: "2022-02-01",
            sell: 0,
            strongBuy: 17,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
    
    static func example4() -> RecommendInfo {
        RecommendInfo(
            buy: 25,
            hold: 7,
            period: "2022-01-01",
            sell: 0,
            strongBuy: 17,
            strongSell: 0,
            symbol: "AAPL"
        )
    }
}

typealias RecommendInfos = [RecommendInfo]

func RecommendInfoList() -> RecommendInfos {
    [
        RecommendInfo.example1(),
        RecommendInfo.example2(),
        RecommendInfo.example3(),
        RecommendInfo.example4()
    ]
}

extension APILinkable where Self == RecommendInfos {
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "recommend/\(stockTicker)")
    }
}


//
//  EarningInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct EarningInfo: Codable, ReflectedStringConvertible {
    let actual: Float32
    let estimate: Float32
    let period: String
    let surprise: Float32
    let surprisePercent: Float32
    let symbol: String
    
    static func example1() -> EarningInfo {
        EarningInfo(
            actual: 2.1,
            estimate: 1.9268,
            period: "2022-03-31",
            surprise: 0.1732,
            surprisePercent: 8.989,
            symbol: "AAPL"
        )
    }
    
    static func example2() -> EarningInfo {
        EarningInfo(
            actual: 1.24,
            estimate: 1.261,
            period: "2021-12-31",
            surprise: -0.021,
            surprisePercent: -1.6653,
            symbol: "AAPL"
        )
    }
    
    static func example3() -> EarningInfo {
        EarningInfo(
            actual: 1.3,
            estimate: 1.0269,
            period: "2021-09-30",
            surprise: 0.2731,
            surprisePercent: 26.5946,
            symbol: "AAPL"
        )
    }
    
    static func example4() -> EarningInfo {
        EarningInfo(
            actual: 1.4,
            estimate: 1.0064,
            period: "2021-06-30",
            surprise: 0.3936,
            surprisePercent: 39.1097,
            symbol: "AAPL"
        )
    }
}

typealias EarningInfos = [EarningInfo]

func EarningInfoList() -> [EarningInfo] {
    [
        EarningInfo.example1(),
        EarningInfo.example2(),
        EarningInfo.example3(),
        EarningInfo.example4()
    ]
}

extension APILinkable where Self == EarningInfos {
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "earnings/\(stockTicker)")
    }
}


//
//  SocialSentiment.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct SocialSentiment: Codable, ReflectedStringConvertible {
    let atTime: String
    let mention: Int32
    let positiveScore: Float32
    let negativeScore: Float32
    let positiveMention: Int32
    let negativeMention: Int32
    let score: Float32
    
    static func example1() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-11 02:00:00",
            mention: 4,
            positiveScore: 0.991375,
            negativeScore: 0,
            positiveMention: 4,
            negativeMention: 0,
            score: 0.991375
        )
    }
    
    static func example2() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-11 01:00:00",
            mention: 5,
            positiveScore: 0.98899975,
            negativeScore: -0.99964607,
            positiveMention: 4,
            negativeMention: 1,
            score: 0.991129014
        )
    }
    
    static func example3() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-11 00:00:00",
            mention: 1,
            positiveScore: 0,
            negativeScore: -0.8038017,
            positiveMention: 0,
            negativeMention: 1,
            score: 0.8038017
        )
    }
    
    static func example4() -> SocialSentiment {
        SocialSentiment(
            atTime: "2022-04-10 22:00:00",
            mention: 1,
            positiveScore: 0,
            negativeScore: -0.9982066,
            positiveMention: 0,
            negativeMention: 1,
            score: 0.9982066
        )
    }
}

typealias SocialSentiments = [SocialSentiment]

func SocialSentimentList() -> [SocialSentiment] {
    [
        SocialSentiment.example1(),
        SocialSentiment.example2(),
        SocialSentiment.example3(),
        SocialSentiment.example4()
    ]
}

extension APILinkable where Self == SocialSentiments {
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "social-sentiments/\(stockTicker)")
    }
}


//
//  StockInfo.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import Foundation

struct StockInfo: ReflectedStringConvertible {
    var companyBrief = CompanyBrief()
    var currentPrice = CurrentPrice()
    var hourlyPrice  = HourlyPrice()
    var peers = Peers()
    var news = News()
    var historicRecord = HistoricalRecord()
    var recommendInfos = RecommendInfos()
    var earningInfos = EarningInfos()
    var socialSentiments = SocialSentiments()
    
    mutating func updateProperty(name: String, value: AnyObject) {
        switch name {
        case "companyBrief": self.companyBrief = value as! CompanyBrief
        case "currentPrice": self.currentPrice = value as! CurrentPrice
        case "hourlyPrice": self.hourlyPrice = value as! HourlyPrice
        case "peers": self.peers = value as! Peers
        case "news": self.news = value as! News
        case "historicRecord": self.historicRecord = value as! HistoricalRecord
        case "recommendInfos": self.recommendInfos = value as! RecommendInfos
        case "earningInfos": self.earningInfos = value as! EarningInfos
        case "socialSentiments": self.socialSentiments = value as! SocialSentiments
        default: fatalError("Wrong Key")
        }
    }
}


//
//  SingleItemQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/12/22.
//

import Foundation

class SingleItemQuery<T: APILinkable & Codable>: Serviceable {
    var data: T
    let updateFunc: (AnyObject) -> Void
    var errorMessage: String? = nil
    
    init(data: T, update: @escaping (AnyObject) -> Void) {
        self.data = data
        self.updateFunc = update
    }
    
    func startQuery(stockTicker: String, group: DispatchGroup) {
        let APIFetcher = APIService()
        print(type(of: data))
        print("Fetching API from \(data.API_URL(stockTicker: stockTicker))")
        
        APIFetcher.fetch(T.self, url: data.API_URL(stockTicker: stockTicker), completion: {[unowned self] result in
            DispatchQueue.main.async {
                defer {
                    group.leave()
                }

                switch result {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print(error)
                    case .success(let result):
                        print("--- sucess with \(result)")
                        self.updateFunc(result as AnyObject)
                }
            }
        })
    }
}

class SingleItemDependentQuery<T: APILinkable & Codable & Dependable>: SingleItemQuery<T> {
    let myWaitQueue: DispatchGroup = DispatchGroup()
    let semaphore: DispatchSemaphore
    let serialQueue = DispatchQueue(label: "Serial queue")
    let getDependent: () -> T.DependDataType
    
    init(data: T, update: @escaping (AnyObject) -> Void,
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


//
//  StockQuery.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/11/22.
//

import Foundation

class StockQuery: ObservableObject {
    let stockTicker: String
    @Published var isLoading: Bool = false
    @Published var stockData = StockInfo()
    var APIServices: [Serviceable] = []
    let semaphore = DispatchSemaphore(value: 0)
    var currentTime = NATime
    
    init(for stockTicker: String) {
        self.stockTicker = stockTicker
        APIServicesInit()
    }
    
    func APIServicesInit() {
        APIServices = [
//            SingleItemQuery<CompanyBrief>(data: stockData.companyBrief,
//                                          update: update(propertyName: "companyBrief")),
//            SingleItemQuery<CurrentPrice>(data: stockData.currentPrice,
//                                          update: { value in
//                                              self.currentTime = (value as! CurrentPrice).timestamp
//                                              self.semaphore.signal()
//                                              self.update(propertyName: "currentPrice")(value)
//                                          }),
//            SingleItemDependentQuery<HourlyPrice>(data: stockData.hourlyPrice,
//                                                  update: update(propertyName: "hourlyPrice"),
//                                                  getUpdatedDependent: self.getUpdatedTime,
//                                                  semaphore: semaphore),
//            SingleItemQuery<Peers>(data: stockData.peers,
//                                          update: update(propertyName: "peers")),
//            SingleItemQuery<News>(data: stockData.news,
//                                  update: update(propertyName: "news")),
//            SingleItemQuery<HistoricalRecord>(data: stockData.historicRecord,
//                                              update: update(propertyName: "historicRecord")),
//            SingleItemQuery<RecommendInfos>(data: stockData.recommendInfos,
//                                            update: update(propertyName: "recommendInfos")),
//            SingleItemQuery<EarningInfos>(data: stockData.earningInfos,
//                                          update: update(propertyName: "earningInfos")),
            SingleItemQuery<SocialSentiments>(data: stockData.socialSentiments,
                                              update: update(propertyName: "socialSentiments")),
        ]
    }
    
    func update(propertyName: String) -> (AnyObject) -> Void {
        return { value in
            self.stockData.updateProperty(name: propertyName, value: value)
        }
    }
    
    func getUpdatedTime() -> TimeInterval {
        return self.currentTime
    }
    
    func startQuery() {
        let group = DispatchGroup()
        isLoading = true
        
        for service in APIServices {
            group.enter()
            service.startQuery(stockTicker: stockTicker, group: group)
        }
        
        group.notify(queue: .main, execute: {
            self.isLoading = false
            print("All Tasks finished")
            print(self.stockData)
        })
    }
}

let ticker = "AAPL"
let query = StockQuery(for: ticker)
query.startQuery()

//func newsExample() -> News {
//    return [SingleNews.example1(), SingleNews.example2()]
//}
//
//var info = newsExample()
////print(info.API_URL(stockTicker: "AAPL") ?? "Empty")
//
////var single_query = SingleItemQuery<News>(data: info,
////                                         update: { value in
////    info = value as! News
////})
////single_query.startQuery(stockTicker: "AAPL", group: DispatchGroup())
//
//func test<T: APILinkable>(data: T, for ticker: String) {
//    print(data.API_URL(stockTicker: ticker))
//}
//
//test(data: info, for: "AAPL")
