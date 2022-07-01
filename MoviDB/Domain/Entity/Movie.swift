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

struct Genre: Codable {
    
    //MARK: Properties
    
    var id: Int
    var name: String
}
