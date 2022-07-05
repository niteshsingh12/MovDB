//
//  DefaultMovieRepository.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import Combine

final class DefaultMovieRepository: MovieRepository {
    
    //MARK: Properties
    
    var manager: NetworkManager
    
    //MARK: Initializer
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    //MARK: Methods
    
    func fetchMovies<T: Codable>(with endpoint: EndpointAssembler) -> AnyPublisher<MovieListWrapper<T>, NetworkError> {
        manager.fetch(with: endpoint).eraseToAnyPublisher()
    }
}

extension DefaultMovieRepository: MovieDetailRepository {
    
    func fetchSimilarMovies<T: Codable>(with endpoint: EndpointAssembler) -> AnyPublisher<MovieListWrapper<T>, NetworkError> {
        manager.fetch(with: endpoint).eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(endpoint: EndpointAssembler) -> AnyPublisher<Movie, NetworkError> {
        manager.fetch(with: endpoint).eraseToAnyPublisher() 
    }
}
