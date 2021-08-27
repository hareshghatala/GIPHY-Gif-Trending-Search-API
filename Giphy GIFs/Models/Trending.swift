//
//  Trending.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

public struct Trending: Codable {
    
    public let data: [GifData]?
    public let pagination: Pagination?
    
}

extension Trending: Equatable {
    
    public static func ==(lhs: Trending, rhs: Trending) -> Bool {
        return lhs.data == rhs.data &&
            lhs.pagination == rhs.pagination
    }
    
}

