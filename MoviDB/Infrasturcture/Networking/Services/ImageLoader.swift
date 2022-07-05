//
//  ImageLoader.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import Combine
import UIKit

enum ImageLoadError: Error {
    case malformedURL
    case cacheError
    case networkError
    case imageNotFound
}

enum ImageStatus {
    case downloading(_ task: Task<UIImage, Error>)
    case downloaded(_ image: UIImage)
}

protocol ImageLoaderProtocol {
    func image(from url: URL) async throws -> UIImage
    func downloadImage(url: URL) async throws -> UIImage
}

actor ImageLoader: ImageLoaderProtocol {
    
    private var cache: [URL: ImageStatus] = [:]
    
    func image(from url: URL) async throws -> UIImage {
        if let imageStatus = cache[url] {
            switch imageStatus {
            case .downloading(let task):
                return try await task.value
            case .downloaded(let image):
                return image
            }
        }
        
        let task = Task {
            try await downloadImage(url: url)
        }
        
        cache[url] = .downloading(task)
        
        do {
            let image = try await task.value
            cache[url] = .downloaded(image)
            return image
        } catch {
            // If an error occurs, we will evict the URL from the cache
            // and rethrow the original error.
            cache.removeValue(forKey: url)
            throw error
        }
    }
    
    internal func downloadImage(url: URL) async throws -> UIImage {
        
        let imageRequest = URLRequest(url: url)
        let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageLoadError.networkError
        }
        return image
    }
}
