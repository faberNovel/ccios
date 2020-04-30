//
//  TestViewController.swift
//  ProjectName
//
//  Created by Georges Abitbol on 01/01/1970.
//
//

import Foundation
import UIKit

class TestViewController: SharedViewController, TestViewContract {
    var presenter: TestPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.start()
    }

    // MARK: - TestViewContract

}
