//
//  APIService.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

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
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            // Define each potential Error
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
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
