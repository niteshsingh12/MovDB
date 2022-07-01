//
//  AppCoordinator.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit

final class AppCoordinator: AppBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    
    lazy var homeCoordinator: HomeBaseCoordinator = HomeCoordinator()
    lazy var rootViewController: UIViewController  = UITabBarController()
    lazy var childCoordinators: [Coordinator] = []
    
    // MARK: - Methods
    
    func start() -> UIViewController {
        let homeViewController = homeCoordinator.start()
        homeCoordinator.parentCoordinator = self
        return homeViewController
    }
    
    func didFinish(_ child: Coordinator) {
        removeChild(child)
    }
}
