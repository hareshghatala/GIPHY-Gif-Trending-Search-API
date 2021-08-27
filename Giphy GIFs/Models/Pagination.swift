//
//  Pagination.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

public struct Pagination: Codable {
    
    public let totalCount: Int?
    public let count: Int?
    public let offset: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count = "count"
        case offset = "offset"
    }
    
}
