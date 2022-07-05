//
//  MovieDetailTests.swift
//  MoviDBTests
//
//  Created by Nitesh Singh on 05/07/22.
//

import XCTest
import Combine
@testable import MoviDB

class MovieDetailTests: XCTestCase {
    // custom urlsession for mock network calls
    var urlSession: URLSession!
    var cancellabels: Set<AnyCancellable>!
    var movieRepo: MovieDetailRepository!
    var viewModel: MovieDetailViewModel!
    
    var sut: MovieDetailViewController!
    var testMovie: Movie!
    
    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        cancellabels = Set<AnyCancellable>()
        
        let networkManager: NetworkManager = DefaultNetworkManager(urlSession)
        movieRepo = DefaultMovieRepository(manager: networkManager)
        
        viewModel = MovieDetailViewModel(repository: movieRepo)
        
        test_fetchJSON()
        sut = MovieDetailViewController(viewModel: viewModel, imageLoader: ImageLoader(), movie: testMovie)
    }
    
    func test_fetchJSON() {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MovieDetailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        do {
            testMovie = try JSONDecoder().decode(Movie.self, from: mockData)
        } catch {
            XCTFail("JSON Decoding Failed")
        }
    }
    
    func test_homeVCInitialization() {
        XCTAssertNotNil(sut.viewModel)
    }
    
    @MainActor func test_fetchMovieDetail_CheckIfCorrectMovieReceived() {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MovieDetailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.viewModel.fetchMovieDetail(for: "1234")
        viewModel.movieDetail.sink(receiveCompletion: { (completion) in}, receiveValue: { (movie) in
            XCTAssertEqual(movie.id, 335787)
            expectation.fulfill()
        })
            .store(in: &cancellabels)
    }
}

