//
//  TestCoordinator.swift
//  ProjectName
//
//  Created by Georges Abitbol on 01/01/1970.
//
//

import Foundation
import ADCoordinator

protocol TestCoordinatorDelegate: AnyObject {

}

class TestCoordinator: Coordinator {

    weak var delegate: TestCoordinatorDelegate?
    private let dependencyProvider: ApplicationDependencyProvider
    private unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController,
         dependencyProvider: ApplicationDependencyProvider) {
        self.navigationController = navigationController
        self.dependencyProvider = dependencyProvider
    }

    // MARK: - Public

    func start() {
        let viewController = UIViewController()
        navigationController.pushViewController(viewController, animated: false)
        bindToLifecycle(of: viewController)
    }
}
