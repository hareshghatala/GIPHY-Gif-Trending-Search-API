//
//  FileHandler.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/26.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

public class FileHandler {
    
    static let fileManager = FileManager.default
    
    // MARK: - Class methods
    
    class func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    class func getGifListFromDocumentsDirectory() -> [URL] {
        do {
            let items = try fileManager.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return items.filter { $0.pathExtension == "gif" }
        } catch {
            print(error)
        }
        
        return []
    }
    
    class func saveGif(fileName: String, images: [UIImage]) {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        createAndSaveGIF(with: images, path: path, frameDelay: 0.15)
    }
    
    class func removeGif(fileName: String) {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        removeGif(filePath: path)
    }
    
    class func removeGif(filePath: URL) {
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Private methods
    
    private class func createAndSaveGIF(with images: [UIImage], path: URL, frameDelay: Double = 0.1) {
        let destinationGIF = CGImageDestinationCreateWithURL(path as CFURL, kUTTypeGIF, images.count, nil)!
        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]

        for img in images {
            let cgImage = img.cgImage
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary?)
        }

        CGImageDestinationFinalize(destinationGIF)
    }
    
}
