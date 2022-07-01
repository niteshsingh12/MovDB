//
//  RequestError.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation

enum NetworkError: Error, Equatable {
    
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
                
            case (.decodingError, .decodingError):
                return true
            case (let .serverError(lhs), let .serverError(rhs)):
                return lhs == rhs
            case (let .clientError(lhs), let .clientError(rhs)):
                return lhs == rhs
            case (let .sessionFailed(lhs), let .sessionFailed(rhs)):
                return lhs == rhs
            default:
                return false
        }
    }
    
    case badRequest
    case malformedURL
    case decodingError
    case unauthorized
    case forbidden
    case notFound
    case serverError(code: Int)
    case clientError(code: Int)
    case failed
    case sessionFailed(_ error: URLError)
    case other(error: Error)
    case unknownError
}
