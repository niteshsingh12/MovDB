//
//  Movie.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation

struct Movie: Codable, Hashable {
    
    //MARK: Properties
    
    var id: Int
    var adult: Bool
    var backdrop_path: String?
    var budget: Int?
    var genres: [Genre]?
    var genre_ids: [Int]?
    var homepage: String?
    var title: String
    var original_title: String
    var original_language: String
    var overview: String
    var popularity: Double
    var poster_path: String?
    var release_date: String
    var revenue: Int?
    var runtime: Int?
    var tagline: String?
    var vote_average: Double
    var vote_count: Int
    var production_companies: [ProductionCompany]?
    var production_countries: [ProductionCountry]?
    var credits: Credits?
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func getGenres() -> String {
        guard let genres = genre_ids?.prefix(2) else { return "" }
        return Array(genres).map {
            if let genre = MovieGenre(rawValue: $0) {
                return String(describing: genre)
            }
            return ""
        }.joined(separator: ", ")
    }
}

extension Movie {
    var imagePath: URL? {
        guard let path = poster_path else { return nil }
        return URL(string: AppConstants.imageBaseURL + path)
    }
    var backdrop_imagePath: URL? {
        guard let path = backdrop_path else { return nil }
        return URL(string: AppConstants.imageBaseURL + path)
    }
}

struct Genre: Codable {
    
    //MARK: Properties
    
    var id: Int
    var name: String
}

struct ProductionCompany: Codable {
    
    //MARK: Properties
    
    var id: Int
    var logo_path: String?
    var name: String
    var origin_country: String
}

struct ProductionCountry: Codable {
    
    //MARK: Properties
    
    var iso_3166_1: String
    var name: String
}

struct Credits: Codable {
    
    //MARK: Properties
    
    var cast: [Cast]
}
