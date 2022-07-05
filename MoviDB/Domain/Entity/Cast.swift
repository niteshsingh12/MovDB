//
//  Cast.swift
//  MoviDB
//
//  Created by Nitesh Singh on 05/07/22.
//

import Foundation

struct Cast: Codable, Hashable {
    
    //MARK: Properties
    
    var id: Int
    var name: String
    var profile_path: String?
    var character: String
    
    // MARK: - Protocol Confirmance
    
    static func == (lhs: Cast, rhs: Cast) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.character == rhs.character
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(character)
    }
}

extension Cast {
    var imagePath: URL? {
        guard let path = profile_path else { return nil }
        return URL(string: AppConstants.imageBaseURL + path)
    }
}
