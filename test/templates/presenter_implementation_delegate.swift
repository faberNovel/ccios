//
//  TestPresenterImplementation.swift
//  ProjectName
//
//  Created by Georges Abitbol on 01/01/1970.
//
//

import Foundation

class TestPresenterImplementation : TestPresenter {

    private weak var viewContract: TestViewContract?
    private weak var delegate: TestPresenterDelegate?

    init(viewContract: TestViewContract, delegate: TestPresenterDelegate) {
        self.viewContract = viewContract
        self.delegate = delegate
    }

    // MARK: - TestPresenter

    func start() {

    }
}
