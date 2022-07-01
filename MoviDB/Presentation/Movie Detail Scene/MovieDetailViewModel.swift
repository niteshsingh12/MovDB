//
//  MovieDetailViewModel.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import Combine

final class MovieDetailViewModel {
    
    var movie = PassthroughSubject<Movie, NetworkError>()
    var state = PassthroughSubject<ViewModelState, Never>()
    
    var manager: NetworkManager
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    func fetchMovieDetails(for id: String) {
        
    }
}
