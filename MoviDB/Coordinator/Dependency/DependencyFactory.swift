//
//  DependencyFactory.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

class DependencyFactory {
    
    //MARK: Dependency Methods
    
    /*
     Dependencies For Home Scene
     */
    func createHomeViewController() -> HomeViewController {
        let homeVC = HomeViewController(viewModel: createHomeViewModel(), imageLoader: ImageLoader())
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

extension DependencyFactory {
    
    /*
     Dependencies For Detail Scene
     */
    func createDetailViewController(movie: Movie) -> MovieDetailViewController {
        let detailVC = MovieDetailViewController(viewModel: createMovieDetailViewModel(), imageLoader: ImageLoader(), movie: movie)
        return detailVC
    }
    
    func createMovieDetailViewModel() -> MovieDetailViewModel {
        return MovieDetailViewModel(repository: createMovieDetailRepository())
    }
    
    func createMovieDetailRepository() -> MovieDetailRepository {
        return DefaultMovieRepository(manager: createNetworkManager())
    }
}
