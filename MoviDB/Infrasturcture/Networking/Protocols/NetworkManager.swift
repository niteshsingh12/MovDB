//
//  NetworkManager.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import Combine

protocol NetworkManager {
    func fetch<T: Codable>(with endpoint: EndpointAssembler) -> AnyPublisher<T, NetworkError>
    func fetch<T: Codable>(with url: URL) -> AnyPublisher<T, NetworkError>
}
