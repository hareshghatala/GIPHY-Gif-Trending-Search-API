//
//  ImageDetails.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

public struct ImageDetails: Codable {
    
    public let height: String?
    public let width: String?
    public let size: String?
    public let url: String?
    
}

extension ImageDetails: Equatable {
    
    public static func ==(lhs: ImageDetails, rhs: ImageDetails) -> Bool {
        return lhs.height == rhs.height &&
            lhs.width == rhs.width &&
            lhs.size == rhs.size &&
            lhs.url == rhs.url
    }
    
}
