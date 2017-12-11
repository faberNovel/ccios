//
//  TestViewController.swift
//  ProjectName
//
//  Created by Georges Abitbol on 01/01/1970.
//
//

import Foundation
import UIKit

class TestViewController : SharedViewController, TestViewContract {
    var presenter: TestPresenter?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.start()
    }

    // MARK: - TestViewContract

}
