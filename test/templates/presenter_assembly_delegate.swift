container.register(TestPresenter.self) { r, viewContract, delegate in
    TestPresenterImplementation(
        viewContract: viewContract,
        delegate: delegate
    )
}
