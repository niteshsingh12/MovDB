//
//  MovieViewModel.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import Combine

final class MovieViewModel {
    
    //MARK: Properties
    
    @Published var moviePublisher: Movie?
    private var movie: Movie
    
    //MARK: Initializer
    
    init(with movie: Movie) {
        self.movie = movie
    }
    
    //MARK: Methods
    
    func publish() {
        moviePublisher = movie
    }
}
