//
//  HomeCoordinator.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import UIKit

import Foundation

protocol HomeBaseCoordinator: Coordinator {
    func moveToMovieDetailWith(movie: Movie)
    func moveBackToHomePage()
}

final class HomeCoordinator: HomeBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    lazy var childCoordinators: [Coordinator] = []
    
    var factory = DependencyFactory()
    
    // MARK: - Methods
    
    func start() -> UIViewController {
        let homeViewController = factory.createHomeViewController()
        homeViewController.coordinator = self
        rootViewController = UINavigationController(rootViewController: homeViewController)
        return rootViewController
    }
    
    func moveToMovieDetailWith(movie: Movie) {
        
    }
    
    func moveBackToHomePage() {
        navigationRootViewController?.popViewController(animated: true)
        navigationRootViewController?.navigationBar.isHidden = false
    }
    
    func didFinish(_ child: Coordinator) {
        removeChild(child)
    }
    
    // MARK: - Navigation Appearance
    
    private func configureNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        appearance.shadowColor = .clear

        let navigationBar = navigationRootViewController!.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.isHidden = false
    }
    
    private func hideNavigationBar() {
        let navigationBar = navigationRootViewController!.navigationBar
        navigationBar.isHidden = true
    }
}
