//
//  HomeViewModelTests.swift
//  MoviDBTests
//
//  Created by Nitesh Singh on 01/07/22.
//

import XCTest
import Combine
@testable import MoviDB

class HomeViewTests: XCTestCase {
    // custom urlsession for mock network calls
    var urlSession: URLSession!
    var cancellabels: Set<AnyCancellable>!
    var movieRepo: MovieRepository!
    var viewModel: HomeViewModel!
    
    var sut: HomeViewController!

    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        cancellabels = Set<AnyCancellable>()
        
        let networkManager: NetworkManager = DefaultNetworkManager(urlSession)
        movieRepo = DefaultMovieRepository(manager: networkManager)
        
        viewModel = HomeViewModel(repository: movieRepo)
        
        sut = HomeViewController(viewModel: viewModel)
    }
    
    func test_homeVCInitialization() {
        XCTAssertNotNil(sut.viewModel)
    }
    
    func test_fetchMovies_CheckIfCorrectSectionReceived() {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MoviesJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.viewModel.fetchMovies(with: .nowPlaying)
        
        viewModel.movies.sink(receiveCompletion: { (completion) in
            
        }, receiveValue: { (movies) in
            
            XCTAssertTrue(!movies.0.isEmpty)
            XCTAssertEqual(movies.0[0].release_date, "2022-05-04")
            XCTAssertTrue(movies.1 == .nowPlaying)
            expectation.fulfill()
        })
            .store(in: &cancellabels)
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
