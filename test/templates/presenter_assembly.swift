container.register(TestPresenter.self) { r, viewContract in
    TestPresenterImplementation(
        viewContract: viewContract
    )
}
