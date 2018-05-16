container.register(TestPresenter.self) { _, viewContract in
    TestPresenterImplementation(
        viewContract: viewContract
    )
}
