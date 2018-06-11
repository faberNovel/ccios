container.register(TestPresenter.self) { _, viewContract, delegate in
    TestPresenterImplementation(
        viewContract: viewContract,
        delegate: delegate
    )
}
