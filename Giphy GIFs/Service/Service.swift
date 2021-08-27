//
//  Service.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/24.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

public enum ServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

class Service {
    
    public static let shared = Service()
    private init() {}
    
    private let urlSession = URLSession.shared
    
    private let baseURL = URL(string: giphyBaseURLString)!
    private let apiKey = giphyApiKey
    private let limit = apiDataLimit
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    /// Enum endpoints
    enum Endpoint: String {
        case trending
        case search
    }
    
    /// Query parameters
    enum QueryParams: String {
        case apiKey = "api_key"
        case limit = "limit"
        case offset = "offset"
        case searchQuery = "q"
    }
    
    private func fetchResources<T: Decodable>(url: URL, queryParams: [String: String]? = nil, completion: @escaping (Result<T, ServiceError>) -> Void) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        if let queryParams = queryParams?.map({ URLQueryItem(name: $0.key, value: $0.value) }) {
            urlComponents.queryItems = queryParams
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        print("Request Url: \(url.absoluteString)")
        urlSession.dataTask(with: url) { result in
            switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        print(error)
                        completion(.failure(.decodeError))
                    }
                
                case .failure( _):
                    completion(.failure(.apiError))
            }
        }.resume()
    }
    
    
    public func fetchTrendingGif(offset: Int = 0, result: @escaping (Result<Trending, ServiceError>) -> Void) {
        
        let params: [String: String] = [ QueryParams.apiKey.rawValue: apiKey,
                                         QueryParams.limit.rawValue: "\(limit)",
                                         QueryParams.offset.rawValue: "\(offset)"]
        
        let infoURL = baseURL.appendingPathComponent(Endpoint.trending.rawValue)
        
        fetchResources(url: infoURL, queryParams: params, completion: result)
    }
    
    public func SearchGif(searchText: String, offset: Int = 0, result: @escaping (Result<Trending, ServiceError>) -> Void) {

        let params: [String: String] = [ QueryParams.apiKey.rawValue: apiKey,
                                         QueryParams.searchQuery.rawValue: searchText,
                                         QueryParams.limit.rawValue: "\(limit)",
                                         QueryParams.offset.rawValue: "\(offset)"]
        
        let infoURL = baseURL.appendingPathComponent(Endpoint.search.rawValue)
        
        fetchResources(url: infoURL, queryParams: params, completion: result)
    }
    
}
