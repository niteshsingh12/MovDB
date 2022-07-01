//
//  AppBaseCoordinator.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

protocol AppBaseCoordinator: Coordinator {
    var homeCoordinator: HomeBaseCoordinator { get }
}

protocol HomeBaseCoordinated {
    var coordinator: HomeBaseCoordinator? { get }
}
