func testPresenter(viewContract: TestViewContract, presenterDelegate: TestPresenterDelegate) -> TestPresenter? {
    return presenterAssembler
        .resolver
        .resolve(TestPresenter.self, arguments: viewContract, presenterDelegate)
}
