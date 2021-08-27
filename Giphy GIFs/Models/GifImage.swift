//
//  GifImage.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

public struct GifImage: Codable {
    
    public let original: ImageDetails?
    public let downsizedMedium: ImageDetails?
    public let fixedHeightDownsampled: ImageDetails?
    public let fixedWidthDownsampled: ImageDetails?
    
    
    func urlForOriginal() -> URL? {
        guard let imgDetail = original,
              let imgUrl = imgDetail.url else {
            return nil
        }
        
        return URL(string: imgUrl)
    }
    
    func urlForDownsizedMedium() -> URL? {
        guard let imgDetail = downsizedMedium,
              let imgUrl = imgDetail.url else {
            return nil
        }
        
        return URL(string: imgUrl)
    }
    
    func urlForFixedHeightDownsampled() -> URL? {
        guard let imgDetail = fixedHeightDownsampled,
              let imgUrl = imgDetail.url else {
            return nil
        }
        
        return URL(string: imgUrl)
    }
    
    func urlForFixedWidthDownsampled() -> URL? {
        guard let imgDetail = fixedWidthDownsampled,
              let imgUrl = imgDetail.url else {
            return nil
        }
        
        return URL(string: imgUrl)
    }
    
}
