//
//  MovieRepository.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import Combine

protocol MovieRepository {
    func fetchMovies<T: Codable>(with endpoint: EndpointAssembler) -> AnyPublisher<MovieListWrapper<T>, NetworkError>
}
