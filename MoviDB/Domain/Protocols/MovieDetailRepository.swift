//
//  MovieDetailRepository.swift
//  MoviDB
//
//  Created by Nitesh Singh on 01/07/22.
//

import Foundation
import Combine

protocol MovieDetailRepository {
    func fetchMovieDetail(endpoint: EndpointAssembler) -> AnyPublisher<Movie, NetworkError>
    func fetchSimilarMovies<T: Codable>(with endpoint: EndpointAssembler) -> AnyPublisher<MovieListWrapper<T>, NetworkError>
}
