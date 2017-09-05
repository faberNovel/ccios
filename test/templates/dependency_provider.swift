func testPresenter(viewContract: TestViewContract) -> TestPresenter? {
    return presenterAssembler
        .resolver
        .resolve(TestPresenter.self, argument: viewContract)
}
