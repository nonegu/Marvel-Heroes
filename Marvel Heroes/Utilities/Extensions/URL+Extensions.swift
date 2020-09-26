//
//  URL+Extensions.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation



extension URL {
    func appending(_ queryItem: String, value: String) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)

        queryItems.append(queryItem)
        
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
    func appending(_ newItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        queryItems.append(contentsOf: newItems)
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    func transformToHttps() -> URL? {
        let http = self.absoluteString
        var urlComponents = URLComponents(string: http)
        urlComponents?.scheme = "https"
        return urlComponents?.url
    }
    
    func thumbnailImageURL(_ type: ThumbnailTypes, fileExtension: String) -> URL? {
        guard let urlString = self.transformToHttps()?.absoluteString else { return nil }
        return URL(string: urlString + "/\(type.rawValue)" + ".\(fileExtension)")
    }
}
