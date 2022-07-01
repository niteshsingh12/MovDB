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

typealias FutureImage = Future<UIImage, ImageLoadError>

protocol ImageLoader {
    func loadImage(for url: String) -> FutureImage
    func cancelLoad(_ urlString: String)
}

final class DefaultImageLoader: ImageLoader {
    
    var cancellable: AnyCancellable?
    private var cancellables = [String: AnyCancellable]()
    var manager: NetworkManager
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    func loadImage(for urlString: String) -> FutureImage {
        
        return FutureImage { [weak self] (promise) in
            
            let string = "https://image.tmdb.org/t/p/w500" + urlString
            
            if let cachedImage = DefaultCacheService.shared.get(for: string) {
                return promise(.success(cachedImage))
            }
            
            guard let url = URL(string: string) else {
                return promise(.failure(.malformedURL))
            }
            
            self?.cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map {
                    UIImage(data: $0.data)}
                .replaceError(with: nil)
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] (image) in
                    
                    defer { self?.cancellables.removeValue(forKey: string) }
                    
                    if let image = image {
                        DefaultCacheService.shared.set(image: image, for: string)
                        promise(.success(image))
                    } else {
                        promise(.failure(ImageLoadError.imageNotFound))
                    }
                    self?.cancellables[string] = self?.cancellable
                })
        }
    }
    
    func cancelLoad(_ urlString: String) {
        
        let string = "https://image.tmdb.org/t/p/w500" + urlString
        cancellables[string]?.cancel()
        cancellables.removeValue(forKey: string)
    }
}
