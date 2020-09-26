//
//  MarvelAPI.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

enum Errors: Error {
    case noData
    case noResponse
    case errorOccured(msg: String)
    case timedOut
    case dataProcessError
    case noRefreshTokenFound
}

class MarvelAPI {
    
    static let timeStampValue = Date().timeIntervalSince1970
    static let apiPublicKey = "ENTER_YOUR_PUBLIC_KEY_HERE"
    static let apiPrivateKey = "ENTER_YOUR_PRIVATE_KEY_HERE"
    static let md5HashKey = "\(timeStampValue)\(apiPrivateKey)\(apiPublicKey)".MD5()
    
    enum Endpoints {
        static let baseURLString = "https://gateway.marvel.com/v1/public"
        static let timeStampParam = URLQueryItem(name: "ts", value: "\(timeStampValue)")
        static let apiKeyParam = URLQueryItem(name: "apikey", value: "\(apiPublicKey)")
        static let hashParam = URLQueryItem(name: "hash", value: "\(md5HashKey)")
        
        case getCharacters
        case getComicsWith(characterID: String)
        
        var stringValue: String {
            switch self {
            case .getCharacters:
                return Endpoints.baseURLString + "/characters"
            case .getComicsWith(let id):
                return Endpoints.getCharacters.stringValue + "/\(id)/comics"
            }
        }
        
        var authorizedURL: URL {
            var urlComponents = URLComponents(string: self.stringValue)!
            urlComponents.queryItems = [Endpoints.timeStampParam, Endpoints.hashParam, Endpoints.apiKeyParam]
            return urlComponents.url!
        }
    }
    
    /// Generic GET Request
    /// - Parameters:
    ///   - request: URLRequest to required service
    ///   - responseType: Data model of expected response
    /// - Note:
    ///    This method will return a result type with given response.
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(request: URLRequest, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, Errors>) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.errorOccured(msg: error!.localizedDescription)))
                return
            }
            guard let data = data else { completion(.failure(.noData)); return }
            guard response != nil else { completion(.failure(.noResponse)); return }
            
//            print(String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.dataProcessError))
                    return
                }
            }
        }
        task.resume()
        
        return task
    }
    
    /// This (HTTP GET) method is used to retrive the characters for given limit and offset values.
    /// - Note:
    ///    This method will return a result type with Character.
    class func getCharacters(limit: Int, offset: Int, completion: @escaping (Result<[Character], Errors>) -> Void) {
        let url = Endpoints.getCharacters.authorizedURL
            .appending("limit", value: "\(limit)")
            .appending("offset", value: "\(offset)")
        
        print(url)
        taskForGETRequest(request: URLRequest(url: url), responseType: MarvelDataWrapper<Character>.self) { (result) in
            switch result {
            case .success(let response):
                guard let characterResults = response.data?.results else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(characterResults))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension URL {

    func appending(_ queryItem: String, value: String) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)

        queryItems.append(queryItem)
        
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
