import UIKit
import Foundation

struct CompanyBrief: Codable {
    let ipo: String
    let finnhubIndustry: String
    let name: String
    let ticker: String
    let weburl: URL
    let logo: URL
}

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

@propertyWrapper
struct FailableDecodable<Wrapped: Codable>: Codable {
    
    var wrappedValue: Wrapped?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            print("Here 1")
            wrappedValue = nil;
            return
        } else {
            print("Here 2")
            wrappedValue = try container.decode(Wrapped.self)
        }
//        wrappedValue = try? container.decode(Wrapped.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
    
    init() {
        self.wrappedValue = nil
    }
    
    init(_ value: Wrapped) {
        self.wrappedValue = value
    }
}

struct SingleNews: Codable, Identifiable {
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

    init(id: Int64, source: String, headline: String, summary: String, url: URL, image: URL, datetime: TimeInterval){
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
}

func timestampToString(_ datetime: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = SingleNews.dateFormat
    return dateFormatter.string(from: Date(timeIntervalSince1970: datetime))
}


let APIURL = URL(string: "http://kecheng-ye-hw8.us-east-1.elasticbeanstalk.com/api/news/AAPL")
let _APIService = APIService()
_APIService.fetch([SingleNews].self, url: APIURL) { result in
    DispatchQueue.main.async {
        switch result {
        case .failure(let error):
            let errorMessage = error.description
            print(errorMessage)
        case .success(let data):
            let result = data
            print(result[1])
        }
    }
}

//let data = """
//{"category":"company","datetime":1649611504,"headline":"Dow Jones Futures: Market Rally Ailing, But These Stocks Are Healthy; Tesla Forges New Entry","id":109072509,"image":"","related":"AAPL","source":"Yahoo","summary":"The market rally is increasingly split. Tesla reversed lower, but has a handle. Callon leads stocks trading tightly.","url":"https://finnhub.io/api/news?id=6fced1b8122e6f6b7e9bc9c252f425fd51c406e24779451e1d2a0b49ffb8207f"}
//""".data(using: .utf8)!
//
//let decoder = JSONDecoder()
//let product = try decoder.decode(SingleNews.self, from: data)
//
//print(product)
