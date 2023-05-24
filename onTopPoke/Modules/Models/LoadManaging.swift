protocol LoadManaging {
    var isLoading: Bool { get set }
    func startLoading()
    func stopLoading()
}
