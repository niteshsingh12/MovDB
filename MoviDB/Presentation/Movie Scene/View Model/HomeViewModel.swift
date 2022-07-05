//
//  HomeViewModel.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import Combine

enum ViewModelState {
    case loading
    case finishedLoading
    case finishedWithError(error: NetworkError)
}

enum MovieType: Int {
    
    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    func getTitle() -> String {
        switch self {
            case .nowPlaying:
                return "Now Playing"
            case .popular:
                return "Popular"
            case .topRated:
                return "Top Rated"
            case .upcoming:
                return "Upcoming"
        }
    }
}

final class HomeViewModel {
    
    //MARK: Properties
    
    var movies = PassthroughSubject<([Movie], MovieType), NetworkError>()
    var state = PassthroughSubject<ViewModelState, Never>()
    var type: MovieType = .nowPlaying
    private var repository: MovieRepository
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Initializer
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    //MARK: Methods
    
    func fetchMovies(with type: MovieType) {
        
        var endpoint: EndpointAssembler
        
        switch type {
        case .nowPlaying:
            endpoint = .fetchNowPlayingMovies
        case .popular:
            endpoint = .fetchPopularMovies
        case .topRated:
            endpoint = .fetchTopRatedMovies
        case .upcoming:
            endpoint = .fetchUpcomingMovies
        }
        
        self.type = type
        fetchMovies(with: endpoint, type: type)
    }
    
    private func fetchMovies(with endpoint: EndpointAssembler, type: MovieType) {
        state.send(.loading)
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            switch completion {
            case .failure(let error):
                self.state.send(.finishedWithError(error: error))
            case .finished:
                self.state.send(completion: .finished)
            }
        }
        
        let valueHandler: (MovieListWrapper<Movie>) -> Void = { (moviesWrapper) in
            self.movies.send((moviesWrapper.results, type))
        }
        
        repository.fetchMovies(with: endpoint)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
    
    private func fetchMovieDetail(with endpoint: EndpointAssembler, type: MovieType) {
        state.send(.loading)
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            switch completion {
            case .failure(let error):
                self.state.send(.finishedWithError(error: error))
            case .finished:
                self.state.send(completion: .finished)
            }
        }
        
        let valueHandler: (MovieListWrapper<Movie>) -> Void = { (moviesWrapper) in
            self.movies.send((moviesWrapper.results, type))
        }
        
        repository.fetchMovies(with: endpoint)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
}
