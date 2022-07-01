//
//  DependencyFactory.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

class DependencyFactory {
    
    func createHomeViewController() -> HomeViewController {
        let homeVC = HomeViewController(viewModel: createHomeViewModel())
        return homeVC
    }
    
    func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(repository: createMovieRepository())
    }
    
    func createMovieRepository() -> MovieRepository {
        return DefaultMovieRepository(manager: createNetworkManager())
    }
    
    func createNetworkManager() -> NetworkManager {
        return DefaultNetworkManager(URLSession(configuration: .default))
    }
}
