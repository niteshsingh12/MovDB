//
//  MovieTest.swift
//  MoviDBTests
//
//  Created by Nitesh Singh on 05/07/22.
//

import Foundation
import XCTest
@testable import MoviDB

class MovieTests: XCTestCase {
    
    let testMovie = Movie(id: 335787, adult: false, title: "test Movie", original_title: "Test Movie", original_language: "en", overview: "test", popularity: 5.0, release_date: "", vote_average: 5.0, vote_count: 2)
    
    func test_MovieHashable() {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MovieDetailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: mockData)
            XCTAssertEqual(movie.hashValue, testMovie.hashValue)
            
        } catch {
            XCTFail("JSON Decoding Failed")
        }
    }
    
    func test_MovieEquality() {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MovieDetailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: mockData)
            XCTAssertEqual(movie, testMovie)
            
        } catch {
            XCTFail("JSON Decoding Failed")
        }
    }
    
    func test_CastImagePathGeneration() throws {
        
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "MovieDetailJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: mockData)
            XCTAssertEqual(movie.imagePath, URL(string: AppConstants.imageBaseURL500 + movie.poster_path!))
            XCTAssertEqual(movie.backdrop_imagePath, URL(string: AppConstants.imageBaseURL500 + movie.backdrop_path!))
            
        } catch {
            XCTFail("JSON Decoding Failed")
        }
    }
}
