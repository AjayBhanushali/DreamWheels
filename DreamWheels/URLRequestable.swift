//
//  URLRequestable.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 13/12/20.
//

import Foundation

protocol URLRequestable {
    /// Check if self can be assignged as URLRequest
    func asURLRequest() throws -> URLRequest
}


extension URLRequestable where Self: NetworkAPIEndPoint {
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.path = path
        components?.queryItems = queryItems(from: parameters)
        
        guard let url = components?.url else {
            let URL = baseURL
            throw NetworkError.invalidRequestURL(URL.appendingPathComponent(path))
        }
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = method.rawValue
        request.setHeaders(headers)
        return request
    }
    
    private func queryItems(from params: [String: Any]) -> [URLQueryItem] {
        let queryItems: [URLQueryItem] = params.compactMap { parameter -> URLQueryItem? in
            var result: URLQueryItem?
            if let intValue = parameter.value as? Int {
                result = URLQueryItem(name: parameter.key, value: String(intValue))
            } else if let stringValue = parameter.value as? String {
                result = URLQueryItem(name: parameter.key, value: stringValue)
            } else if let boolValue = parameter.value as? Bool {
                let value = boolValue ? "1" : "0"
                result = URLQueryItem(name: parameter.key, value: value)
            } else {
                return nil
            }
            return result
        }
        return queryItems
    }
}

extension URLRequest {
    mutating func setHeaders(_ headers: [String: String]? = nil) {
        guard let headers = headers else {
            return
        }
        headers.forEach {
            setValue($0.key, forHTTPHeaderField: $0.value)
        }
    }
}
