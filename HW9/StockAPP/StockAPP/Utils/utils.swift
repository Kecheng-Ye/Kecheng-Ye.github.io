//
//  utils.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation
import SwiftUI

typealias Price = Float32

let APILink = "http://kecheng-ye-hw8.us-east-1.elasticbeanstalk.com/api/"
//let APILink = "http://127.0.0.1:5555/api/"
let FinnhubLink = "https://finnhub.io/"
let NAString = "N.A"
let NAInt: Int32 = 0
let NAFloat: Float32 = 0
let NATime: TimeInterval = 0
let NAPrice: Price = 0
let NAURL: URL? = nil

let DEBUG = false
let START_BALANCE: Price = 25000
let NEWS_LIMIT: Int = 20

// Time Interval
let MAIN_PAGE_AUTO_UPDATE_INTERVAL = 15.0
let SLPASH_SCREEN_DURATION = 1.0
let TOAST_DURATION = 1.5
let SEARCH_DEBOUNCE_DELAY = 1.0


func timestampToString(_ datetime: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = SingleNews.dateFormat
    return dateFormatter.string(from: Date(timeIntervalSince1970: datetime))
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

func roundToTwoDecimal(_ data: Price) -> String {
    return String(format: "%.2f", data)
}

typealias JSONDict = Dictionary<String, (data: Any, type: Any.Type)>

func toJSONString(_ type: Any.Type, _ data: Any) -> String {
    switch type {
    case is String.Type: return "\"\(data as! String)\""
    case is JSONDict.Type: return encodeJSON(data as! JSONDict)
    default: return "\(data)"
    }
}

func encodeJSON(_ data: JSONDict) -> String {
    var result = "{"

    for (key, value) in data {
        result += toJSONString(String.self, key) + ":"
        result += toJSONString(value.type, value.data) + ","
    }
    
    let _ = result.popLast()
    result += "}"
    return result
}
