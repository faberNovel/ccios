//
//  TestPresenterImplementation.swift
//  ProjectName
//
//  Created by Georges Abitbol on 01/01/1970.
//
//

import Foundation

class TestPresenterImplementation: TestPresenter {

    private weak var viewContract: TestViewContract?

    init(viewContract: TestViewContract) {
        self.viewContract = viewContract
    }

    // MARK: - TestPresenter

    func start() {

    }
}
