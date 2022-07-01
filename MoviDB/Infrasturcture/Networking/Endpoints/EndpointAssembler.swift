//
//  EndpointAssembler.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation

enum EndpointAssembler: RequestBuilder {
    
    //MARK : Endpoints
    
    case fetchNowPlayingMovies
    case fetchPopularMovies
    case fetchTopRatedMovies
    case fetchUpcomingMovies
    case fetchDetails(movieId: String)
    case fetchSimilarMovies(movieId: String)
    
    //MARK : Request Components
    
    var scheme: String {
        switch self {
        default: return "https"
        }
    }
    
    var host: String {
        switch self {
        default: return "api.themoviedb.org"
        }
    }
    
    var path: String {
        switch self {
        case .fetchNowPlayingMovies: return "/3/movie/now_playing"
        case .fetchPopularMovies: return "/3/movie/popular"
        case .fetchTopRatedMovies: return "/3/movie/top_rated"
        case .fetchUpcomingMovies: return "/3/movie/upcoming"
        case .fetchDetails(let movieId): return "/3/movie/\(movieId)"
        case .fetchSimilarMovies(let movieId): return "/3/movie/\(movieId)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        
        let apiKey = "f641cb53cfaac25038f3bf4f43569695"
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        switch self {
        default: return queryItems
        }
    }
    
    var requestType: RequestMethod {
        switch self {
        default: return .get
        }
    }
}
