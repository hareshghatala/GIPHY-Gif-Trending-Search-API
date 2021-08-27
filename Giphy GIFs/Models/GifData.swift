//
//  GifData.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

public struct GifData: Codable {
    
    public let id: String?
    public let title: String?
    public let images: GifImage?
    public var isFavourite: Bool? = false
    
    
    func gifUrl() -> URL? {
        if let fixedHeightUrl = images?.urlForFixedHeightDownsampled() {
            return fixedHeightUrl
        } else if let fixedWidthUrl = images?.urlForFixedWidthDownsampled() {
            return fixedWidthUrl
        } else if let downsizedUrl = images?.urlForDownsizedMedium() {
            return downsizedUrl
        } else if let originalUrl = images?.urlForOriginal() {
            return originalUrl
        } else {
            return nil
        }
    }
    
    func generateFileName() -> String {
        guard let gifId = id else {
            return "none.gif"
        }
        
        return "\(gifId).gif"
    }
}
