//
//  TestCoordinator.swift
//  ProjectName
//
//  Created by Georges Abitbol on 01/01/1970.
//
//

import Foundation

protocol TestCoordinatorDelegate: AnyObject {

}

class TestCoordinator: Coordinator {

    weak var delegate: TestCoordinatorDelegate?
    private let dependencyProvider: ApplicationDependencyProvider
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         dependencyProvider: ApplicationDependencyProvider) {
        self.navigationController = navigationController
        self.dependencyProvider = dependencyProvider
    }

    // MARK: - Public

    func start() {

    }
}
