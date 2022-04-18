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
