//
//  ImageCachingService.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//
//  This is the Image Caching Service that downloads and caches the images as
//  soon as they are fetched from the network request
//

import Foundation
import UIKit

enum ImageSize: String {
    case small
    case large
}

final class ImageCachingService {
    static let shared = ImageCachingService()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }()

    func loadImage(from url: URL, uuid: String, size: ImageSize, forceRefresh: Bool = false) async throws -> UIImage {
        let key = "\(uuid)-\(size.rawValue)"
        let nsKey = NSString(string: key)
        let diskURL = cacheDirectory.appendingPathComponent(key + ".img")

        if forceRefresh {
            memoryCache.removeObject(forKey: nsKey)
            try? fileManager.removeItem(at: diskURL)
            print("Force refresh: removed old image for \(key)")
        } else {
            if let cached = memoryCache.object(forKey: nsKey) {
                return cached
            }

            if fileManager.fileExists(atPath: diskURL.path),
               let data = try? Data(contentsOf: diskURL),
               let image = UIImage(data: data) {
                memoryCache.setObject(image, forKey: nsKey)
                print("Loaded from disk: \(key)")
                return image
            }
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: diskURL)

        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Image decode failed", code: 0)
        }

        memoryCache.setObject(image, forKey: nsKey)
        print("Downloaded & cached: \(key)")
        return image
    }

    func clear() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        print("Cleared all cached images.")
    }
}
