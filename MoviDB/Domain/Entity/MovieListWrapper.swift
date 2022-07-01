//
//  MovieListWrapper.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation

struct MovieListWrapper<T: Codable>: Codable {
    
    //MARK: Properties
    
    var page: Int
    var results: [T]
    var total_pages: Int
    var total_results: Int
}
