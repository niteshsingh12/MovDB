//
//  MovieDetailViewModel.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import Combine

final class MovieDetailViewModel {
    
    //MARK: Properties
    
    var movieDetail = PassthroughSubject<Movie, NetworkError>()
    var similarMovies = PassthroughSubject<[Movie], NetworkError>()
    var state = PassthroughSubject<ViewModelState, Never>()
    private var repository: MovieDetailRepository
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Initializer
    
    init(repository: MovieDetailRepository) {
        self.repository = repository
    }
    
    //MARK: Methods
    
    /*
      Fetches similar movies
    */
    @MainActor func fetchSimilarMovies(for id: String) {
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            switch completion {
            case .failure(let error):
                self.state.send(.finishedWithError(error: error))
            case .finished:
                self.state.send(completion: .finished)
            }
        }
        
        let valueHandler: (MovieListWrapper<Movie>) -> Void = { (moviesWrapper) in
            self.similarMovies.send(moviesWrapper.results)
        }
        
        repository.fetchSimilarMovies(with: .fetchSimilarMovies(movieId: id))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
    
    /*
      Fetches movie details along with movie casts
    */
    @MainActor func fetchMovieDetail(for id: String) {
        state.send(.loading)
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            switch completion {
            case .failure(let error):
                self.state.send(.finishedWithError(error: error))
            case .finished:
                self.state.send(completion: .finished)
            }
        }
        
        let valueHandler: (Movie) -> Void = { (movie) in
            self.movieDetail.send(movie)
        }
        
        repository.fetchMovieDetail(endpoint: .fetchDetails(movieId: id))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
}
