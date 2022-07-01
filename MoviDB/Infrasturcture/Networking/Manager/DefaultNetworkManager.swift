//
//  DefaultNetworkManager.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import Combine
import UIKit

final class DefaultNetworkManager: NetworkManager {
    
    //MARK: Properties
    
    var session: URLSession
    
    //MARK: Initializer
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    //MARK: Methods
    
    func fetch<T: Codable>(with endpoint: EndpointAssembler) -> AnyPublisher<T, NetworkError> {
        
        let url = endpoint.buildComponent().url
        
        guard let url = url else {
            return Fail(error: NetworkError.malformedURL).eraseToAnyPublisher()
        }
        return fetch(with: url)
    }
    
    func fetch<T: Codable>(with url: URL) -> AnyPublisher<T, NetworkError> {
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap ({ (data, response) in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) { throw self.httpError(response.statusCode) }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { (error) in
                self.handleMapError(error)
            }
            .retry(1)
            .eraseToAnyPublisher()
    }
}

extension DefaultNetworkManager {
    
    private func httpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .clientError(code: statusCode)
        case 500...599: return .serverError(code: statusCode)
        default: return .unknownError
        }
    }
    
    private func handleMapError(_ error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .sessionFailed(urlError)
        case let error as NetworkError:
            return error
        default:
            return .unknownError
        }
    }
}
