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
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start() {

    }
}
