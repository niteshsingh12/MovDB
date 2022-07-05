//
//  HomeControllerTests.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import XCTest
import Combine
@testable import MoviDB

class MoviesRepoTests: XCTestCase {
    // custom urlsession for mock network calls
    var urlSession: URLSession!
    var cancellabels: Set<AnyCancellable>!
    var movieRepo: (MovieDetailRepository & MovieRepository)!

    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        cancellabels = Set<AnyCancellable>()
        
        let networkManager: NetworkManager = DefaultNetworkManager(urlSession)
        movieRepo = DefaultMovieRepository(manager: networkManager)
    }
    
    func test_fetchMovies() throws {
        // Set mock data
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MoviesJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
                case .failure: ()
                case .finished: ()
            }
        }
        
        let valueHandler: (MovieListWrapper<Movie>) -> Void = { (movies) in
            XCTAssertTrue(!movies.results.isEmpty, "Movies should not be empty")
            XCTAssertEqual(movies.results[0].original_title, "Doctor Strange in the Multiverse of Madness", "Doctor Strange in the Multiverse of Madness should be first movie")
            XCTAssertEqual(movies.results[1].original_title, "Fantastic Beasts: The Secrets of Dumbledore", "Fantastic Beasts: The Secrets of Dumbledore should be second movie")
            expectation.fulfill()
        }
        
        movieRepo
            .fetchMovies(with: .fetchNowPlayingMovies)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellabels)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchMovieDetail() throws {
        // Set mock data
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MovieDetailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "Expecting Movie Detil JSON")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
                case .failure: ()
                case .finished: ()
            }
        }
        
        let valueHandler: (Movie) -> Void = { (movie) in
            XCTAssertEqual(movie.original_title, "Uncharted", "Movie should be uncharted")
            expectation.fulfill()
        }
        
        movieRepo
            .fetchMovieDetail(endpoint: .fetchDetails(movieId: ""))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellabels)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fail_fetchMovies() throws {
        
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "FailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
                case .failure(let error):
                    XCTAssertEqual(error, .decodingError)
                    expectation.fulfill()
                case .finished: ()
            }
        }
        let valueHandler: (MovieListWrapper<Movie>) -> Void = { (movies) in}
        
        movieRepo
            .fetchMovies(with: .fetchNowPlayingMovies)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellabels)
        
        wait(for: [expectation], timeout: 1)
    }
}
