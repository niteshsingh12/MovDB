//
//  CacheService.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit

protocol CacheService {
    
    func set(image: UIImage, for key: String)
    func get(for key: String) -> UIImage?
}

final class DefaultCacheService: CacheService {
    
    //MARK: Properties
    
    static let shared: CacheService = DefaultCacheService()
    private var imageCache: NSCache<NSString, UIImage>
    
    //MARK: Initializer
    
    private init() {
        imageCache = NSCache()
    }
    
    //MARK: Methods
    
    func set(image: UIImage, for key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func get(for key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
