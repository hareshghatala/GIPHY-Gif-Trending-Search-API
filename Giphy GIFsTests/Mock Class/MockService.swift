//
//  MockService.swift
//  Giphy GIFsTests
//
//  Created by Haresh Ghatala on 2021/08/27.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import XCTest
@testable import Giphy_GIFs

class MockService: Service {
    
    public static let mockShared = MockService()
    override init() {
        super.init()
    }
    
    var isfailur: Bool = false
    var mockServiceError: ServiceError?
    var mockResponse: Trending?
    
    override func fetchTrendingGif(offset: Int = 0, result: @escaping (Result<Trending, ServiceError>) -> Void) {
        if isfailur {
            result(.failure(mockServiceError!))
        } else {
            result(.success(mockResponse!))
        }
    }
    
    override func SearchGif(searchText: String, offset: Int = 0, result: @escaping (Result<Trending, ServiceError>) -> Void) {
        if isfailur {
            result(.failure(mockServiceError!))
        } else {
            result(.success(mockResponse!))
        }
    }
}

